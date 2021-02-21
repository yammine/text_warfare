defmodule TextWarfare.Repo.Migrations.CreateBattles do
  use Ecto.Migration

  def change do
    create table(:battles) do
      add :battle_results, :map
      add :attacker, references(:bases, on_delete: :nothing)
      add :defender, references(:bases, on_delete: :nothing)
      add :winner, references(:bases, on_delete: :nothing)

      timestamps()
    end

    create index(:battles, [:attacker])
    create index(:battles, [:defender])
    create index(:battles, [:winner])
  end
end
