defmodule TextWarfare.Game.Battle do
  use Ecto.Schema
  import Ecto.Changeset

  alias TextWarfare.Game.Base

  schema "battles" do
    field :battle_results, :map
    belongs_to :attacker, Base
    belongs_to :defender, Base
    belongs_to :winner, Base

    timestamps()
  end

  @doc false
  def changeset(battle, attrs) do
    battle
    |> cast(attrs, [:battle_results])
    |> validate_required([:battle_results])
  end
end
