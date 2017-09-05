defmodule Discuss.Repo.Migrations.AddComments do
  use Ecto.Migration

  #Create comments table
  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics)

      timestamps()
    end
  end

end

#select * from comments;
# id | content | user_id | topic_id | inserted_at | updated_at
#----+---------+---------+----------+-------------+------------
#(0 rows)

#\d comments;
#                                      Table "public.comments"
#   Column    |            Type             |                       Modifiers
#-------------+-----------------------------+-------------------------------------------------------
# id          | integer                     | not null default nextval('comments_id_seq'::regclass)
# content     | character varying(255)      |
# user_id     | integer                     |
# topic_id    | integer                     |
# inserted_at | timestamp without time zone | not null
# updated_at  | timestamp without time zone | not null
#Indexes:
#    "comments_pkey" PRIMARY KEY, btree (id)
#Foreign-key constraints:
#    "comments_topic_id_fkey" FOREIGN KEY (topic_id) REFERENCES topics(id)
#    "comments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)
