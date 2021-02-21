defmodule TextWarfareWeb.BaseLiveTest do
  use TextWarfareWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TextWarfare.Game

  @create_attrs %{land: 42, money: 42}
  @update_attrs %{land: 43, money: 43}
  @invalid_attrs %{land: nil, money: nil}

  defp fixture(:base) do
    {:ok, base} = Game.create_base(@create_attrs)
    base
  end

  defp create_base(_) do
    base = fixture(:base)
    %{base: base}
  end

  describe "Index" do
    setup [:create_base]

    test "lists all bases", %{conn: conn, base: base} do
      {:ok, _index_live, html} = live(conn, Routes.base_index_path(conn, :index))

      assert html =~ "Listing Bases"
    end

    test "saves new base", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.base_index_path(conn, :index))

      assert index_live |> element("a", "New Base") |> render_click() =~
               "New Base"

      assert_patch(index_live, Routes.base_index_path(conn, :new))

      assert index_live
             |> form("#base-form", base: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#base-form", base: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.base_index_path(conn, :index))

      assert html =~ "Base created successfully"
    end

    test "updates base in listing", %{conn: conn, base: base} do
      {:ok, index_live, _html} = live(conn, Routes.base_index_path(conn, :index))

      assert index_live |> element("#base-#{base.id} a", "Edit") |> render_click() =~
               "Edit Base"

      assert_patch(index_live, Routes.base_index_path(conn, :edit, base))

      assert index_live
             |> form("#base-form", base: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#base-form", base: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.base_index_path(conn, :index))

      assert html =~ "Base updated successfully"
    end

    test "deletes base in listing", %{conn: conn, base: base} do
      {:ok, index_live, _html} = live(conn, Routes.base_index_path(conn, :index))

      assert index_live |> element("#base-#{base.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#base-#{base.id}")
    end
  end

  describe "Show" do
    setup [:create_base]

    test "displays base", %{conn: conn, base: base} do
      {:ok, _show_live, html} = live(conn, Routes.base_show_path(conn, :show, base))

      assert html =~ "Show Base"
    end

    test "updates base within modal", %{conn: conn, base: base} do
      {:ok, show_live, _html} = live(conn, Routes.base_show_path(conn, :show, base))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Base"

      assert_patch(show_live, Routes.base_show_path(conn, :edit, base))

      assert show_live
             |> form("#base-form", base: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#base-form", base: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.base_show_path(conn, :show, base))

      assert html =~ "Base updated successfully"
    end
  end
end
