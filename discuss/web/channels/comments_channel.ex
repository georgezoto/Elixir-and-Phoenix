defmodule Discuss.CommentsChannel do
  use Phoenix.Channel

  #To authorize the socket to join a topic, we return {:ok, socket} or {:ok, reply, socket}.
  #"topic:subtopic"
  def join(name, _message, socket) do
    IO.puts("def join(name, _message, socket) +++++++++++")
    IO.puts(name)
    {:ok, %{my_header: "my_reply"}, socket}
  end

  #To deny access, we return {:error, reply}.
  def join("comments:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end


end
