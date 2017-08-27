defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
    #A Topic belongs_to one User described by Discuss.User
    belongs_to :user, Discuss.User
    #A Topic has_many Comment described by Discuss.Comment
    has_many :comments, Discuss.Comment
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
