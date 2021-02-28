defmodule TextWarfare.Domain.ProvinceTest do
  use ExUnit.Case, async: true

  alias TextWarfare.Domain.Province

  describe "add_turns/2" do
    test "increases province's turns" do
      province = Province.add_turns(%Province{}, 1)

      assert province.turns == 1
    end

    test "error if turns is negative" do
      assert_raise(FunctionClauseError, fn -> Province.add_turns(%Province{}, -1) end)
    end
  end

  describe "add_money/2" do
    test "increases province's money" do
      province = Province.add_money(%Province{}, 1)

      assert province.money == 1
    end

    test "error if money is negative" do
      assert_raise(FunctionClauseError, fn -> Province.add_money(%Province{}, -1) end)
    end
  end

  describe "add_land/2" do
    test "increases province's land" do
      province = Province.add_land(%Province{}, 1)

      assert province.land_area == 1
    end

    test "error if land is negative" do
      assert_raise(FunctionClauseError, fn -> Province.add_land(%Province{}, -1) end)
    end
  end

  describe "spend_turns/2" do
    test "returns the Province domain object with decreased turns" do
      {:ok, province} = Province.spend_turns(%Province{turns: 1}, 1)

      assert province.turns == 0
    end

    test "error if spend > available turns" do
      {:error, err} = Province.spend_turns(%Province{turns: 3}, 4)

      assert err =~ "not enough turns"
    end

    test "error if spend == 0" do
      {:error, err} = Province.spend_turns(%Province{turns: 2}, 0)

      assert err =~ "expected a positive integer"
    end

    test "error if spend negative" do
      {:error, err} = Province.spend_turns(%Province{turns: 10}, -10)

      assert err =~ "expected a positive integer"
    end
  end

  describe "build/3" do
    test "adds the buildings to the province" do
      p =
        Province.new()
        |> Province.add_turns(100)
        |> Province.add_money(1_000_000)
        |> Province.add_land(10_000)

      {:ok, province} = Province.build(p, :power_plant, 10)

      assert province.buildings.power_plant == 10
    end

    test "error if amount is zero" do
      {:error, err} = Province.build(%Province{}, :power_plant, 0)

      assert err =~ "expected a positive integer"
    end

    test "error if amount is negative" do
      {:error, err} = Province.build(%Province{}, :power_plant, -10)

      assert err =~ "expected a positive integer"
    end

    test "error if invalid building_type" do
      {:error, err} = Province.build(%Province{}, :nursery, 5)

      assert err =~ "expected type to be in"
    end

    test "error if not enough land" do
      {:error, err} = Province.build(%Province{land_area: 100}, :power_plant, 6)

      assert err =~ "not enough land"
    end

    test "error if not enough money" do
      {:error, err} = Province.build(%Province{land_area: 100, money: 4_999}, :power_plant, 5)

      assert err =~ "not enough money"
    end
  end
end
