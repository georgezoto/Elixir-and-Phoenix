defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
    #One time, upon application load, expensive operations go here
  end

  #Called every time a request flows through this plug
  #params in call/2 is whatever is returned from init/1
  #assign/3 takes a conn and returns a conn, so call/2 implicitly returns a conn
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end

  end

end
