defmodule TextWarfare.Domain.Province do
  defstruct id: nil, turns: 0, land_area: 0, money: 0, buildings: %{}, military: %{}

  alias __MODULE__, as: Province

  @type t :: %__MODULE__{}

  @building_types ~w(power_plant barracks armory shipyard airfield oil_derrick)a
  @area_per_building 20
  @monetary_cost_per_building 1_000
  @turn_cost_per_building 1 / 20

  @military_unit_types ~w(infantry armor navy aircraft)a

  def new do
    %Province{
      buildings: building_map(),
      military: military_map()
    }
  end

  defp building_map do
    Map.new(@building_types, &{&1, 0})
  end

  defp military_map do
    Map.new(@military_unit_types, &{&1, Map.new()})
  end

  @doc """
  Increases the number of turns a Province can spend.

  ## Examples

      iex> add_turns(%Province{turns: 1}, 10)
      %Province{turns: 11}
  """
  @spec add_turns(t, pos_integer()) :: t
  def add_turns(province, turns) when turns > 0 do
    %Province{province | turns: province.turns + turns}
  end

  @doc """
  Increases the money a Province has.

  ## Examples

      iex> add_money(%Province{money: 100}, 10)
      %Province{money: 110}
  """
  @spec add_money(t, pos_integer()) :: t
  def add_money(province, money) when money > 0 do
    %Province{province | money: province.money + money}
  end

  @doc """
  Increases the land a Province has.

  ## Examples

      iex> add_land(%Province{land_area: 100}, 10)
      %Province{land_area: 110}
  """
  @spec add_land(t, pos_integer()) :: t
  def add_land(province, land) when land > 0 do
    %Province{province | land_area: province.land_area + land}
  end

  @doc """
  Spends the turns a Province has. Ensures it cannot spend more turns than it has.

  ## Examples

      iex> spend_turns(%Province{turns: 1}, 1)
      {:ok, %Province{}}

      iex> spend_turns(%Province{turns: 1}, 10)
      {:error, "not enough turns"}
  """
  @spec spend_turns(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def spend_turns(province, spend) when spend > 0 do
    new_turns = province.turns - spend

    if new_turns >= 0 do
      {:ok, %Province{province | turns: new_turns}}
    else
      {:error, "not enough turns"}
    end
  end

  def spend_turns(_province, spend) do
    {:error, "expected a positive integer for spend, got: #{inspect(spend)}"}
  end

  @doc """
  Spends the money a Province has. Ensures it cannot spend more money than it has.

  ## Examples

      iex> spend_money(%Province{money: 1}, 1)
      {:ok, %Province{}}

      iex> spend_money(%Province{money: 1}, 10)
      {:error, "not enough money"}
  """
  @spec spend_money(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def spend_money(province, spend) when spend > 0 do
    new_money = province.money - spend

    if new_money >= 0 do
      {:ok, %Province{province | money: new_money}}
    else
      {:error, "not enough money"}
    end
  end

  def spend_money(_province, spend) do
    {:error, "expected a positive integer for spend, got: #{inspect(spend)}"}
  end

  @spec consume_land(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def consume_land(province, consumption) when consumption > 0 do
    if enough_land_to_build?(province, consumption) do
      {:ok, province}
    else
      {:error, "not enough land"}
    end
  end

  def consume_land(_province, consumption) do
    {:error, "expected a positive integer for consumption, got: #{inspect(consumption)}"}
  end

  @spec build(t, Atom.t(), pos_integer()) :: {:ok, t} | {:error, String.t()}
  def build(province, type, amount) when type in @building_types and amount > 0 do
    with {:ok, province} <- consume_land(province, land_cost(amount)),
         {:ok, province} <- spend_money(province, building_money_cost(amount)),
         {:ok, province} <- spend_turns(province, building_turn_cost(amount)) do
      {:ok, add_buildings(province, type, amount)}
    end
  end

  def build(_province, type, _amount) when type not in @building_types,
    do: {:error, "expected type to be in #{inspect(@building_types)}, got: #{inspect(type)}"}

  def build(_province, _type, amount) when amount <= 0,
    do: {:error, "expected a positive integer for amount, got: #{inspect(amount)}"}

  defp add_buildings(province, type, amount) do
    {_previous, buildings} =
      province.buildings
      |> Map.get_and_update(type, fn c ->
        {c, c + amount}
      end)

    %Province{province | buildings: buildings}
  end

  defp land_cost(n), do: n * @area_per_building

  # Different building types will have different costs later, use fixed one for now
  defp building_money_cost(n), do: n * @monetary_cost_per_building

  defp building_turn_cost(n), do: ceil(n * @turn_cost_per_building)

  defp enough_land_to_build?(province, required_land) do
    province.land_area - used_land(province) >= required_land
  end

  @spec used_land(t) :: non_neg_integer()
  def used_land(%Province{buildings: buildings}) do
    buildings
    |> Map.values()
    |> Enum.sum()
    |> Kernel.*(@area_per_building)
  end
end
