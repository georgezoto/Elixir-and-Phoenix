defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.{User, Topic, Comment}

  #To authorize the socket to join a topic, we return {:ok, socket} or {:ok, reply, socket}.
  #"topic:subtopic"
  #def join(name, _message, socket) do
  #  IO.puts("\n\ndef join(name, _message, socket) +++++++++++")
  #  IO.puts(name)
  #  {:ok, %{my_header: "my_reply"}, socket}
  #end

  #To deny access, we return {:error, reply}.
  #def join("comments:" <> _private_room_id, _params, _socket) do
  #  {:error, %{reason: "unauthorized"}}
  #end

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)

    {:ok, %{my_header: "my_reply"}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content, "userId" => user_id}, socket) do #Bug fixed here
    IO.puts("\n\ndef handle_in(name, message, socket)+++++++++++")
    #IO.inspect(socket)
    IO.puts("Line 28")
    IO.inspect(user_id)
    topic = socket.assigns.topic

    #Bug found here: Using the user_id of the topic shown instead of the user_id of the user logged in.
    #Need conn object here and conn.assigns.user.id
    #user_id = socket.assigns.topic.user_id #Bug fixed here

    #Extract comment's author email if available
    user_email = case user_id do
      nil -> "Anonymous"
      _   -> case user = Repo.get(User, user_id) do
               nil -> "Anonymous"
               _   -> user.email
             end
    end
    IO.puts("Line 44")
    IO.inspect(content)

    changeset = topic
      |> build_assoc(:comments, user_id: user_id) #Bug fixed here
      |> Comment.changeset(%{content: content})
    IO.inspect(changeset)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast! socket, "new_comment", %{content: content, user_email: user_email}
        #IO.inspect(socket)

        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
