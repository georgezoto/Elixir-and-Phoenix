// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
/*let channel = socket.channel("comments:1", {})
channel.join()
  .receive("ok", resp => { console.log("+++Joined successfully+++", resp) })
  .receive("error", resp => { console.log("+++Unable to join+++", resp) })

document.querySelector('button').addEventListener('click', function() {
  channel.push('comments:hello', { hi: 'there!' });
})*/

//Bug found that makes the comment author same as the topic author
//Need to find a way to access/pass the current user in from comments_channel to javascript
const createSocket = (%{"topic_id" => topicId, "user_id" => user_id}) => {
  let messagesContainer = document.querySelector("#div_comments")
  let channel = socket.channel(`comments:${topicId}`, {})

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  document.querySelector('button').addEventListener('click', () => {
    const content = document.querySelector('textarea').value;
    channel.push('comment:add', { content: content });
    console.log("channel.push...content",content)
    document.querySelector('textarea').value = ""
  });

  channel.on("new_comment", payload => {
    console.log("channel.on('new_comment', payload...", payload)
    let messageItem = document.createElement("div");
    //messageItem.innerText = `[${Date()}] ${payload.content}`
    messageItem.innerHTML = `${payload.content} &nbsp &nbsp &nbsp ${new Date().toLocaleDateString("en-US", {
    weekday: "long", year: "numeric", month: "short",
    day: "numeric", hour: "2-digit", minute: "2-digit"})}`
    messagesContainer.appendChild(messageItem)
  });

}

window.createSocket = createSocket;

export default socket
