defmodule Discuss.Repo.Migrations.AddUserIdToTopics do
  use Ecto.Migration

  def change do
    #Add a reference/foreign key from topics to the users table
    alter table(:topics) do
      add :user_id, references(:users)
    end

  end
end
