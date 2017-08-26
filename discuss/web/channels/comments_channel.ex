defmodule Discuss.CommentsChannel do
  use Phoenix.Channel

  def join("topic:comments", _message, socket) do
    {:ok, socket}
  end

  def join("topic:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

end
