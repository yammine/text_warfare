defmodule TextWarfare.Domain.BaseTest do
  use ExUnit.Case, async: true

  alias TextWarfare.Domain.Base

  describe "add_turns/2" do
    test "returns the Base domain object with increased turns" do
      {:ok, base} = Base.add_turns(%Base{}, 1)

      assert base.turns == 1
    end

    test "error if turns == 0" do
      {:error, err} = Base.add_turns(%Base{}, 0)

      assert err =~ "expected a positive integer"
    end

    test "error if turns negative" do
      {:error, err} = Base.add_turns(%Base{}, -10)

      assert err =~ "expected a positive integer"
    end
  end

  describe "spend_turns/2" do
    test "returns the Base domain object with decreased turns" do
      {:ok, base} = Base.spend_turns(%Base{turns: 1}, 1)

      assert base.turns == 0
    end

    test "error if spend > available turns" do
      {:error, err} = Base.spend_turns(%Base{turns: 3}, 4)

      assert err =~ "not enough turns"
    end

    test "error if spend == 0" do
      {:error, err} = Base.spend_turns(%Base{turns: 2}, 0)

      assert err =~ "expected a positive integer"
    end

    test "error if spend negative" do
      {:error, err} = Base.spend_turns(%Base{turns: 10}, -10)

      assert err =~ "expected a positive integer"
    end
  end

  describe "build/3" do
    test "error if amount is zero" do
      {:error, err} = Base.build(%Base{}, :power_plant, 0)

      assert err =~ "expected a positive integer"
    end

    test "error if amount is negative" do
      {:error, err} = Base.build(%Base{}, :power_plant, -10)

      assert err =~ "expected a positive integer"
    end

    test "error if invalid building_type" do
      {:error, err} = Base.build(%Base{}, :nursery, 5)

      assert err =~ "expected type to be in"
    end

    test "error if not enough land" do
      {:error, err} = Base.build(%Base{land_area: 100}, :power_plant, 6)

      assert err =~ "not enough land"
    end

    test "error if not enough money" do
      {:error, err} = Base.build(%Base{land_area: 100, money: 4_999}, :power_plant, 5)

      assert err =~ "not enough money"
    end
  end
end
