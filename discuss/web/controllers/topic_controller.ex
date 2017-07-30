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
    changeset = Topic.changeset(%Topic{}, topic)

    #DB insertion
    case Repo.insert(changeset) do
      {:ok, post} -> IO.inspect(post)
      {:error, changeset} -> 
        render conn, "new.html", changeset: changeset
    end
  end 
end
