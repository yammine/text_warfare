defmodule TextWarfare.Domain.Province do
  defstruct id: nil,
            turns: 0,
            land_area: 0,
            used_land_area: 0,
            money: 0,
            buildings: %{},
            military: %{}

  alias __MODULE__, as: Province

  @type t :: %__MODULE__{}

  @building_types ~w(power_plant barracks armory shipyard airfield oil_derrick)a
  @area_per_building 20
  @monetary_cost_per_building 1_000
  @turn_cost_per_building 1 / 20

  @military_unit_types ~w(infantry armor navy aircraft)a
  @infantry_types ~w(general_infantry)a
  @armor_types ~w(light_tank heavy_tank apc humvee artillery)a
  @navy_types ~w(destroyer carrier)a
  @aircraft_types ~w(fighter bomber)a

  @military_map @military_unit_types
                |> Map.new(&{&1, Map.new()})
                |> Map.put(:infantry, Map.new(@infantry_types, &{&1, 0}))
                |> Map.put(:armor, Map.new(@armor_types, &{&1, 0}))
                |> Map.put(:navy, Map.new(@navy_types, &{&1, 0}))
                |> Map.put(:aircraft, Map.new(@aircraft_types, &{&1, 0}))

  @military_reverse_map Enum.reduce(@military_map, %{}, fn {unit_type, type_map}, acc ->
                          Enum.reduce(type_map, acc, fn {key, _}, sub_acc ->
                            Map.put(sub_acc, key, unit_type)
                          end)
                        end)

  def new do
    %Province{
      buildings: building_map(),
      military: @military_map
    }
  end

  defp building_map do
    Map.new(@building_types, &{&1, 0})
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

  @doc """
  Consumes land_area. Ensures the Province does not build on land it does not have.

  ## Examples

      iex> consume_land(%Province{land_area: 100, used_land_area: 80}, 20)
      {:ok, %Province{land_area: 100, used_land_area: 100}}
  """
  @spec consume_land(t, pos_integer()) :: {:ok, t} | {:error, String.t()}
  def consume_land(province, consumption) when consumption > 0 do
    available_land = province.land_area - province.used_land_area

    if available_land >= consumption do
      {:ok, %Province{province | used_land_area: province.used_land_area + consumption}}
    else
      {:error, "not enough land"}
    end
  end

  def consume_land(_province, consumption) do
    {:error, "expected a positive integer for consumption, got: #{inspect(consumption)}"}
  end

  #### Buildings

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

  # Costs will become dynamic at some point, hard code to these values for now for simplicity
  defp land_cost(n), do: n * @area_per_building
  defp building_money_cost(n), do: n * @monetary_cost_per_building
  defp building_turn_cost(n), do: ceil(n * @turn_cost_per_building)

  #### Military
  @spec train(t, Atom.t(), pos_integer()) :: {:ok, t}
  def train(province, unit, quantity) do
    military_type = military_type_for_unit(unit)

    {_previous, military} =
      get_and_update_in(province.military, [military_type, unit], &{&1, &1 + quantity})

    {:ok, %Province{province | military: military}}
  end

  def military_type_for_unit(unit) do
    Map.get(@military_reverse_map, unit)
  end
end
