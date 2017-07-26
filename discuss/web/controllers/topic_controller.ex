defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def new(conn, _params) do
    #IO.puts "++++"
    #IO.inspect conn
    #IO.puts "++++"
    #IO.inspect params
    changeset = Topic.changeset(%Topic{}, %{})
  
    render conn, "new.html", changeset: changeset
  end
 
  def create(conn, %{"topic" => topic}) do
    topic
  end 
end
