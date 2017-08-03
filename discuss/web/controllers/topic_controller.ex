defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def index(conn, _params) do
    topics = Repo.all(Topic) 
    render conn, "index.html", topics: topics 
  end 

  def new(conn, _params) do
    #IO.puts "++++"
    #IO.inspect conn
    #IO.puts "++++"
    #IO.inspect params
    changeset = Topic.changeset(%Topic{}, %{})
  
    render conn, "new.html", changeset: changeset
  end
 
  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end
 
end
