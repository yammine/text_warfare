defmodule TextWarfare.Domain.Base do
  defstruct id: nil, turns: 0, land_area: 0, money: 0, buildings: %{}, army: %{}

  alias __MODULE__, as: Base

  @type t :: %__MODULE__{}

  @building_types ~w(power_plant barracks armory shipyard oil_derrick)a
  @area_per_building 20
  @monetary_cost_per_building 1_000
  @turn_cost_per_building 1 / 20

  @doc """
  Increases the number of turns a Base can spend.

  ## Examples

      iex> add_turns(%Base{}, 10)
      {:ok, %Base{}}
  """
  @spec add_turns(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def add_turns(base = %Base{turns: n}, turns) when turns > 0 do
    {:ok, %Base{base | turns: n + turns}}
  end

  def add_turns(_base, turns) do
    {:error, "expected a positive integer for turns, got: #{inspect(turns)}"}
  end

  @doc """
  Spends the turns a Base has. Ensures it cannot spend more turns than it has.

  ## Examples

      iex> spend_turns(%Base{}, 1)
      {:ok, %Base{}}

      iex> spend_turns(%Base{}, 10)
      {:error, "not enough turns"}
  """
  @spec spend_turns(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def spend_turns(base = %Base{turns: n}, spend) when spend > 0 do
    new_turns = n - spend

    if new_turns >= 0 do
      {:ok, %Base{base | turns: new_turns}}
    else
      {:error, "not enough turns"}
    end
  end

  def spend_turns(_base, spend) do
    {:error, "expected a positive integer for spend, got: #{inspect(spend)}"}
  end

  @spec build(t, Atom.t(), pos_integer()) :: {:ok, t} | {:error, String.t()}
  def build(base = %Base{}, building_type, amount) do
    with {:building_type, true} <- {:building_type, building_type in @building_types},
         {:amount, true} <- {:amount, amount > 0},
         {:land, true} <- {:land, enough_land_to_build?(base, amount)},
         {:cost, true} <- {:cost, enough_money_to_build?(base, building_type, amount)},
         {:ok, base} <- spend_turns(base, ceil(amount * @turn_cost_per_building)) do
      {:ok, base}
    else
      {:building_type, false} ->
        {:error, "invalid building_type, got: #{inspect(building_type)}"}

      {:amount, false} ->
        {:error, "expected a positive integer for amount, got: #{inspect(amount)}"}

      {:land, false} ->
        {:error, "not enough land"}

      {:cost, false} ->
        {:error, "not enough money"}

      {:error, _msg} = err ->
        err
    end
  end

  defp enough_land_to_build?(base, amount) do
    base.land_area - used_land(base) >= amount * @area_per_building
  end

  # Different building types will have different costs later, use fixed one for now
  defp enough_money_to_build?(base, _type, amount) do
    base.money >= amount * @monetary_cost_per_building
  end

  @spec used_land(t) :: non_neg_integer()
  def used_land(%Base{buildings: buildings}) do
    buildings
    |> Map.values()
    |> Enum.sum()
    |> Kernel.*(@area_per_building)
  end
end
