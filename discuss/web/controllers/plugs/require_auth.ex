defmodule Discuss.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Router.Helpers

  def init(_params) do
    #One time, upon application load, expensive operations go here
  end

  #Called every time a request flows through this plug
  #params in call/2 is whatever is returned from init/1
  #assign/3 takes a conn and returns a conn, so call/2 implicitly returns a conn
  def call(conn, _params) do
    #If a user is signed in let them pass through else redirect them to index
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in.")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
    end

  end

end
