defmodule TextWarfareWeb.BattleLive.Show do
  use TextWarfareWeb, :live_view

  alias TextWarfare.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:battle, Game.get_battle!(id))}
  end

  defp page_title(:show), do: "Show Battle"
  defp page_title(:edit), do: "Edit Battle"
end
