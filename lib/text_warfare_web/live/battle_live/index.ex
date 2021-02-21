defmodule TextWarfareWeb.BattleLive.Index do
  use TextWarfareWeb, :live_view

  alias TextWarfare.Game
  alias TextWarfare.Game.Battle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :battles, list_battles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Battle")
    |> assign(:battle, Game.get_battle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Battle")
    |> assign(:battle, %Battle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Battles")
    |> assign(:battle, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    battle = Game.get_battle!(id)
    {:ok, _} = Game.delete_battle(battle)

    {:noreply, assign(socket, :battles, list_battles())}
  end

  defp list_battles do
    Game.list_battles()
  end
end
