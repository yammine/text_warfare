defmodule TextWarfare.Game.Base do
  use Ecto.Schema
  import Ecto.Changeset

  alias TextWarfare.Accounts.User

  schema "bases" do
    field :land, :integer
    field :money, :integer

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(base, attrs) do
    base
    |> cast(attrs, [:land, :money])
    |> validate_required([:land, :money])
  end

  def create_changeset(base, attrs) do
    base
    |> changeset(attrs)
    |> put_assoc(:user, attrs["user"])
    |> unique_constraint(:user_id)
  end
end
