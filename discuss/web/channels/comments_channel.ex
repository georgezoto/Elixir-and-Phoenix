defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel
  alias Discuss.Topic

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
    IO.puts("\n\ndef join/3 +++++++++++")
    topic_id = String.to_integer(topic_id)
    topic = Repo.get(Topic, topic_id)
    socket = assign(socket, :topic, topic)
    IO.inspect(socket)

    {:ok, %{my_header: "my_reply"}, socket}
  end

  def handle_in(name, message, socket) do
    IO.puts("\n\ndef handle_in(name, message, socket)+++++++++++")
    #broadcast! socket, "new_msg", %{body: body}
    IO.puts(name)
    IO.inspect(message)
    IO.inspect(socket)

    {:reply, :ok, socket}
  end

end
