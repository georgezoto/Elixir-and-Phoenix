defmodule Discuss.Repo.Migrations.AddUserIdToTopics do
  use Ecto.Migration

  #Add a reference/foreign key from topics to the users table
  def change do
    alter table(:topics) do
      add :user_id, references(:users)
    end
  end
  
end
