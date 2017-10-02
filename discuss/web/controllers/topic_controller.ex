defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.{User, Topic, Comment}

  #Flow through the RequireAuth plug prior to these actions using the guard clause
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  #A function plug to check topic ownership
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params) do
    IO.inspect("index(conn, _params)")
    IO.inspect(conn.assigns)

    #Fetches all entries from the data store matching the given query
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    #changeset = Topic.changeset(%Topic{}, topic)
    #Associating a topic with a user
    #Take current user,
    #build an assoc with the topic he is creating,
    #create a Topic struct,
    #create a changeset!

    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    #Inserts a struct or a changeset.
    #In case a struct is given, the struct is converted into a changeset
    #with all non-nil fields as part of the changeset.
    #In case a changeset is given, the changes in the changeset are merged
    #with the struct fields, and all of them are sent to the database.
    #It returns {:ok, struct} if the struct has been successfully inserted
    #or {:error, changeset} if there was a validation or a known constraint error.

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end

  #Bug found that makes the comment author same as the topic author
  def show(conn, %{"id" => topic_id}) do
    #Fetches a single struct from the data store where the primary key matches the given id.
    topic = Repo.get(Topic, topic_id)

    if topic do
      #Fetches all entries from the data store matching the given query
      # Create a query
      query = from c in "comments",
                where: c.topic_id == ^String.to_integer(topic_id),
                select: {c.content, c.user_id, fragment("((? AT TIME ZONE 'UTC') AT TIME ZONE 'EST') AS inserted_at", field(c, :inserted_at))}
                #limit: 3
                #select: {c.content, c.user_id, fragment("date_trunc('day', ?)", field(c, :inserted_at))}

      IO.inspect(query)
      # Send the query to the repository
      results = Repo.all(query)
      IO.puts("def show+++")
      comments = for {content, user_id, inserted_at} <- results do
        IO.inspect(inserted_at)
        {{year, month, day}, {hours, minutes, seconds, _}} = inserted_at
        inserted_at = {{year, month, day}, {hours, minutes, seconds}}
        {:ok, datetime} = NaiveDateTime.from_erl(inserted_at)

        #Extract comment's author email if available
        user_id = case user_id do
          nil -> "Anonymous"
          _   -> case user = Repo.get(User, user_id) do
                   nil -> "Anonymous"
                   _   -> user.email
                 end
        end
        #Return tuple of comment content, author email, comment datetime
        {content, user_id, NaiveDateTime.to_string(datetime)}
      end

      #+References
      #https://hexdocs.pm/ecto/Ecto.Query.html
      #https://hexdocs.pm/ecto/Ecto.Query.API.html#fragment/1
      #https://stackoverflow.com/questions/42939450/elixir-converting-datetime-to-string
      #https://elixirforum.com/t/how-to-convert-db-timestamp-to-naivedatetime/6146
      #https://hexdocs.pm/elixir/NaiveDateTime.html#to_string/1

      #Time zones in PostgreSQL, Elixir and Phoenix
      #https://www.amberbit.com/blog/2017/8/3/time-zones-in-postgresql-elixir-and-phoenix/
      #IO.inspect(comments)

      render conn, "show.html", topic: topic, comments: comments
    else
      conn
      |> put_flash(:info, "You cannot view that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    IO.inspect("edit(conn, %{id => topic_id})")

    #Fetches a single struct from the data store where the primary key matches the given id.
    topic = Repo.get(Topic, topic_id)
    if topic do
      changeset = Topic.changeset(topic)
      render conn, "edit.html", changeset: changeset, topic: topic
    else
      conn
      |> put_flash(:info, "You cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    #changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    #Updates a changeset using its primary key.
    #A changeset is required as it is the only mechanism for tracking dirty changes.
    #Only the fields present in the changes part of the changeset are sent to the database.
    #Any other, in-memory changes done to the schema are ignored.
    #If the struct has no primary key, Ecto.NoPrimaryKeyFieldError will be raised.
    #It returns {:ok, struct} if the struct has been successfully updated or
    #{:error, changeset} if there was a validation or a known constraint error.

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    #Deletes a struct using its primary key.
    #Same as delete/2 but returns the struct or raises if the changeset is invalid
    Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    topic = Repo.get(Topic, topic_id)
    if topic do

      if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
        conn
      else
        conn
        |> put_flash(:error, "You cannot edit that")
        |> redirect(to: topic_path(conn, :index))
        |> halt()
      end

    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end

  end

end
