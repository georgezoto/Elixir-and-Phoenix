defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  #Create users table 
  def change do
    create table(:users) do
      add :email, :string
      add :provider, :string
      add :token, :string

      timestamps()
    end
  end

end

@doc """
select * from users;
 id |       email       | provider |                  token                   |        inserted_at         |         updated_at
----+-------------------+----------+------------------------------------------+----------------------------+----------------------------
  1 | myemail@email.com | github   | 123                                      | 2017-08-23 23:37:09.280797 | 2017-08-23 23:37:09.322251
(1 row)
"""

@doc """
\d users;
                                      Table "public.users"
   Column    |            Type             |                     Modifiers
-------------+-----------------------------+----------------------------------------------------
 id          | integer                     | not null default nextval('users_id_seq'::regclass)
 email       | character varying(255)      |
 provider    | character varying(255)      |
 token       | character varying(255)      |
 inserted_at | timestamp without time zone | not null
 updated_at  | timestamp without time zone | not null
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "comments" CONSTRAINT "comments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)
    TABLE "topics" CONSTRAINT "topics_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)
"""
