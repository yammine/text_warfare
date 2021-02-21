defmodule TextWarfare.Repo.Migrations.CreateBases do
  use Ecto.Migration

  def change do
    create table(:bases) do
      add :land, :integer
      add :money, :integer

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:bases, [:user_id])
  end
end
