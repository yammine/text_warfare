defmodule TextWarfare.Domain.Base do
  defstruct id: nil, turns: 0, land_area: 0, money: 0, buildings: %{}, army: %{}

  alias __MODULE__, as: Base

  @type t :: %__MODULE__{}

  @building_types ~w(power_plant barracks armory shipyard airfield oil_derrick)a
  @area_per_building 20
  @monetary_cost_per_building 1_000
  @turn_cost_per_building 1 / 20

  @army_unit_types ~w(infantry armor navy aircraft)a

  def new do
    %Base{
      buildings: building_map(),
      army: army_map()
    }
  end

  defp building_map do
    Map.new(@building_types, &{&1, 0})
  end

  defp army_map do
    Map.new(@army_unit_types, &{&1, Map.new()})
  end

  @doc """
  Increases the number of turns a Base can spend.

  ## Examples

      iex> add_turns(%Base{}, 10)
      {:ok, %Base{}}
  """
  @spec add_turns(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def add_turns(base, turns) when turns > 0 do
    {:ok, %Base{base | turns: base.turns + turns}}
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
  def spend_turns(base, spend) when spend > 0 do
    new_turns = base.turns - spend

    if new_turns >= 0 do
      {:ok, %Base{base | turns: new_turns}}
    else
      {:error, "not enough turns"}
    end
  end

  def spend_turns(_base, spend) do
    {:error, "expected a positive integer for spend, got: #{inspect(spend)}"}
  end

  @spec spend_money(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def spend_money(base, spend) when spend > 0 do
    new_money = base.money - spend

    if new_money >= 0 do
      {:ok, %Base{base | money: new_money}}
    else
      {:error, "not enough money"}
    end
  end

  def spend_money(_base, spend) do
    {:error, "expected a positive integer for spend, got: #{inspect(spend)}"}
  end

  @spec consume_land(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def consume_land(base, consumption) when consumption > 0 do
    if enough_land_to_build?(base, consumption) do
      {:ok, base}
    else
      {:error, "not enough land"}
    end
  end

  def consume_land(_base, consumption) do
    {:error, "expected a positive integer for consumption, got: #{inspect(consumption)}"}
  end

  @spec build(t, Atom.t(), pos_integer()) :: {:ok, t} | {:error, String.t()}
  def build(base, type, amount) when type in @building_types and amount > 0 do
    with {:ok, base} <- consume_land(base, land_cost(amount)),
         {:ok, base} <- spend_money(base, building_money_cost(amount)),
         {:ok, base} <- spend_turns(base, building_turn_cost(amount)) do
      {:ok, add_buildings(base, type, amount)}
    end
  end

  def build(_base, type, _amount) when type not in @building_types,
    do: {:error, "expected type to be in #{inspect(@building_types)}, got: #{inspect(type)}"}

  def build(_base, _type, amount) when amount <= 0,
    do: {:error, "expected a positive integer for amount, got: #{inspect(amount)}"}

  defp add_buildings(base, type, amount) do
    {_previous, buildings} =
      base.buildings
      |> Map.get_and_update(type, fn c ->
        {c, c + amount}
      end)

    %Base{base | buildings: buildings}
  end

  defp land_cost(n), do: n * @area_per_building

  # Different building types will have different costs later, use fixed one for now
  defp building_money_cost(n), do: n * @monetary_cost_per_building

  defp building_turn_cost(n), do: ceil(n * @turn_cost_per_building)

  defp enough_land_to_build?(base, required_land) do
    base.land_area - used_land(base) >= required_land
  end

  @spec used_land(t) :: non_neg_integer()
  def used_land(%Base{buildings: buildings}) do
    buildings
    |> Map.values()
    |> Enum.sum()
    |> Kernel.*(@area_per_building)
  end
end
