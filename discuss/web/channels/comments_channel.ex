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

  def handle_in(name, %{"content" => content}, socket) do
    IO.puts("\n\ndef handle_in(name, message, socket)+++++++++++")
    IO.inspect(socket)
    #IO.inspect(content)
    topic = socket.assigns.topic

    #Bug found here: Using the user_id of the topic shown instead of the user_id of the user logged in.
    user_id = socket.assigns.topic.user_id
    #Extract comment's author email if available
    user_id = case user_id do
      nil -> "Anonymous"
      _   -> case user = Repo.get(User, user_id) do
               nil -> "Anonymous"
               _   -> user.email
             end
    end
    IO.inspect(user_id)

    changeset = topic
      |> build_assoc(:comments, user_id: topic.user_id)
      |> Comment.changeset(%{content: content})
    IO.inspect(changeset)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast! socket, "new_comment", %{content: content}
        #IO.inspect(socket)

        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
