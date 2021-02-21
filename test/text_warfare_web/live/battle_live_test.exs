defmodule TextWarfareWeb.BattleLiveTest do
  use TextWarfareWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TextWarfare.Game

  @create_attrs %{battle_results: %{}}
  @update_attrs %{battle_results: %{}}
  @invalid_attrs %{battle_results: nil}

  defp fixture(:battle) do
    {:ok, battle} = Game.create_battle(@create_attrs)
    battle
  end

  defp create_battle(_) do
    battle = fixture(:battle)
    %{battle: battle}
  end

  describe "Index" do
    setup [:create_battle]

    test "lists all battles", %{conn: conn, battle: battle} do
      {:ok, _index_live, html} = live(conn, Routes.battle_index_path(conn, :index))

      assert html =~ "Listing Battles"
    end

    test "saves new battle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.battle_index_path(conn, :index))

      assert index_live |> element("a", "New Battle") |> render_click() =~
               "New Battle"

      assert_patch(index_live, Routes.battle_index_path(conn, :new))

      assert index_live
             |> form("#battle-form", battle: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#battle-form", battle: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.battle_index_path(conn, :index))

      assert html =~ "Battle created successfully"
    end

    test "updates battle in listing", %{conn: conn, battle: battle} do
      {:ok, index_live, _html} = live(conn, Routes.battle_index_path(conn, :index))

      assert index_live |> element("#battle-#{battle.id} a", "Edit") |> render_click() =~
               "Edit Battle"

      assert_patch(index_live, Routes.battle_index_path(conn, :edit, battle))

      assert index_live
             |> form("#battle-form", battle: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#battle-form", battle: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.battle_index_path(conn, :index))

      assert html =~ "Battle updated successfully"
    end

    test "deletes battle in listing", %{conn: conn, battle: battle} do
      {:ok, index_live, _html} = live(conn, Routes.battle_index_path(conn, :index))

      assert index_live |> element("#battle-#{battle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#battle-#{battle.id}")
    end
  end

  describe "Show" do
    setup [:create_battle]

    test "displays battle", %{conn: conn, battle: battle} do
      {:ok, _show_live, html} = live(conn, Routes.battle_show_path(conn, :show, battle))

      assert html =~ "Show Battle"
    end

    test "updates battle within modal", %{conn: conn, battle: battle} do
      {:ok, show_live, _html} = live(conn, Routes.battle_show_path(conn, :show, battle))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Battle"

      assert_patch(show_live, Routes.battle_show_path(conn, :edit, battle))

      assert show_live
             |> form("#battle-form", battle: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#battle-form", battle: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.battle_show_path(conn, :show, battle))

      assert html =~ "Battle updated successfully"
    end
  end
end
