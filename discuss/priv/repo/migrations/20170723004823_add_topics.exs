defmodule Discuss.Repo.Migrations.AddTopics do
  use Ecto.Migration

  #Create topics table
  def change do
    create table(:topics) do
      add :title, :string
    end

  end
end

@doc """
select * from topics;
 id |            title            | user_id
----+-----------------------------+---------
  1 | Postgres in Action (NEW)    |       1
  2 | Elixir Points of Discussion |       1
  3 | Javascript for dinner       |       1
  4 | Elixir and Phoenix          |       1
  5 | Postgres for All!           |       1
  6 | Great JS Frameworks         |       1
(6 rows)
"""

@doc """
\d topics
                                 Table "public.topics"
 Column  |          Type          |                      Modifiers
---------+------------------------+-----------------------------------------------------
 id      | integer                | not null default nextval('topics_id_seq'::regclass)
 title   | character varying(255) |
 user_id | integer                |
Indexes:
    "topics_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "topics_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)
Referenced by:
    TABLE "comments" CONSTRAINT "comments_topic_id_fkey" FOREIGN KEY (topic_id) REFERENCES topics(id)
"""
