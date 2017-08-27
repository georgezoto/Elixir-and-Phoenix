defmodule Discuss.CommentsChannel do
  use Phoenix.Channel

  #"topic:comments"
  def join(name, _message, socket) do
    IO.puts("+++++++++++++++++++++++++")
    IO.puts(name)
    {:ok, %{my_header: my_reply}, socket}
  end

  #Return error for unauthorized topics
  def join("topic:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

end
