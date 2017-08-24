defmodule Discuss.Comment do
  use Discuss.Web, :model

  schema "comments" do
    field :content, :string
    #A Comment belongs_to one User described by Discuss.User
    belongs_to :user, Discuss.User
    #A Comment belongs_to one Topic described by Discuss.Topic
    belongs_to :topic, Discuss.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end
