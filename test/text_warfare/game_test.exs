defmodule TextWarfare.GameTest do
  use TextWarfare.DataCase

  alias TextWarfare.Game

  describe "bases" do
    alias TextWarfare.Game.Base

    @valid_attrs %{land: 42, money: 42}
    @update_attrs %{land: 43, money: 43}
    @invalid_attrs %{land: nil, money: nil}

    def base_fixture(attrs \\ %{}) do
      {:ok, base} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_base()

      base
    end

    test "list_bases/0 returns all bases" do
      base = base_fixture()
      assert Game.list_bases() == [base]
    end

    test "get_base!/1 returns the base with given id" do
      base = base_fixture()
      assert Game.get_base!(base.id) == base
    end

    test "create_base/1 with valid data creates a base" do
      assert {:ok, %Base{} = base} = Game.create_base(@valid_attrs)
      assert base.land == 42
      assert base.money == 42
    end

    test "create_base/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_base(@invalid_attrs)
    end

    test "update_base/2 with valid data updates the base" do
      base = base_fixture()
      assert {:ok, %Base{} = base} = Game.update_base(base, @update_attrs)
      assert base.land == 43
      assert base.money == 43
    end

    test "update_base/2 with invalid data returns error changeset" do
      base = base_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_base(base, @invalid_attrs)
      assert base == Game.get_base!(base.id)
    end

    test "delete_base/1 deletes the base" do
      base = base_fixture()
      assert {:ok, %Base{}} = Game.delete_base(base)
      assert_raise Ecto.NoResultsError, fn -> Game.get_base!(base.id) end
    end

    test "change_base/1 returns a base changeset" do
      base = base_fixture()
      assert %Ecto.Changeset{} = Game.change_base(base)
    end
  end

  describe "battles" do
    alias TextWarfare.Game.Battle

    @valid_attrs %{battle_results: %{}}
    @update_attrs %{battle_results: %{}}
    @invalid_attrs %{battle_results: nil}

    def battle_fixture(attrs \\ %{}) do
      {:ok, battle} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_battle()

      battle
    end

    test "list_battles/0 returns all battles" do
      battle = battle_fixture()
      assert Game.list_battles() == [battle]
    end

    test "get_battle!/1 returns the battle with given id" do
      battle = battle_fixture()
      assert Game.get_battle!(battle.id) == battle
    end

    test "create_battle/1 with valid data creates a battle" do
      assert {:ok, %Battle{} = battle} = Game.create_battle(@valid_attrs)
      assert battle.battle_results == %{}
    end

    test "create_battle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_battle(@invalid_attrs)
    end

    test "update_battle/2 with valid data updates the battle" do
      battle = battle_fixture()
      assert {:ok, %Battle{} = battle} = Game.update_battle(battle, @update_attrs)
      assert battle.battle_results == %{}
    end

    test "update_battle/2 with invalid data returns error changeset" do
      battle = battle_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_battle(battle, @invalid_attrs)
      assert battle == Game.get_battle!(battle.id)
    end

    test "delete_battle/1 deletes the battle" do
      battle = battle_fixture()
      assert {:ok, %Battle{}} = Game.delete_battle(battle)
      assert_raise Ecto.NoResultsError, fn -> Game.get_battle!(battle.id) end
    end

    test "change_battle/1 returns a battle changeset" do
      battle = battle_fixture()
      assert %Ecto.Changeset{} = Game.change_battle(battle)
    end
  end
end
