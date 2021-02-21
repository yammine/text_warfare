defmodule TextWarfare.Game do
  @moduledoc """
  The Game context.
  """

  import Ecto.Query, warn: false
  alias TextWarfare.Repo

  alias TextWarfare.Game.{Base, Battle}

  ##################

  @doc """
  Returns the list of bases.

  ## Examples

      iex> list_bases()
      [%Base{}, ...]

  """
  def list_bases do
    Repo.all(Base)
  end

  @doc """
  Gets a single base.

  Raises `Ecto.NoResultsError` if the Base does not exist.

  ## Examples

      iex> get_base!(123)
      %Base{}

      iex> get_base!(456)
      ** (Ecto.NoResultsError)

  """
  def get_base!(id) do
    query =
      from b in Base,
        where: b.id == ^id,
        preload: [:user]

    Repo.one!(query)
  end

  def get_base_by_user_id!(user_id) do
    query =
      from b in Base,
        where: b.user_id == ^user_id,
        preload: [:user]

    Repo.one!(query)
  end

  @doc """
  Creates a base.

  ## Examples

      iex> create_base(%{field: value})
      {:ok, %Base{}}

      iex> create_base(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_base(attrs \\ %{}) do
    %Base{}
    |> Base.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a base.

  ## Examples

      iex> update_base(base, %{field: new_value})
      {:ok, %Base{}}

      iex> update_base(base, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_base(%Base{} = base, attrs) do
    base
    |> Base.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a base.

  ## Examples

      iex> delete_base(base)
      {:ok, %Base{}}

      iex> delete_base(base)
      {:error, %Ecto.Changeset{}}

  """
  def delete_base(%Base{} = base) do
    Repo.delete(base)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking base changes.

  ## Examples

      iex> change_base(base)
      %Ecto.Changeset{data: %Base{}}

  """
  def change_base(%Base{} = base, attrs \\ %{}) do
    Base.changeset(base, attrs)
  end

  @doc """
  Returns the list of battles.

  ## Examples

      iex> list_battles()
      [%Battle{}, ...]

  """
  def list_battles do
    Repo.all(Battle)
  end

  @doc """
  Gets a single battle.

  Raises `Ecto.NoResultsError` if the Battle does not exist.

  ## Examples

      iex> get_battle!(123)
      %Battle{}

      iex> get_battle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_battle!(id), do: Repo.get!(Battle, id)

  @doc """
  Creates a battle.

  ## Examples

      iex> create_battle(%{field: value})
      {:ok, %Battle{}}

      iex> create_battle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_battle(attrs \\ %{}) do
    %Battle{}
    |> Battle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a battle.

  ## Examples

      iex> update_battle(battle, %{field: new_value})
      {:ok, %Battle{}}

      iex> update_battle(battle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_battle(%Battle{} = battle, attrs) do
    battle
    |> Battle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a battle.

  ## Examples

      iex> delete_battle(battle)
      {:ok, %Battle{}}

      iex> delete_battle(battle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_battle(%Battle{} = battle) do
    Repo.delete(battle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking battle changes.

  ## Examples

      iex> change_battle(battle)
      %Ecto.Changeset{data: %Battle{}}

  """
  def change_battle(%Battle{} = battle, attrs \\ %{}) do
    Battle.changeset(battle, attrs)
  end
end
