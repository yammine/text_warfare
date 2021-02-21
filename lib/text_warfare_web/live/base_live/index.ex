defmodule TextWarfareWeb.BaseLive.Index do
  use TextWarfareWeb, :live_view

  alias TextWarfare.Game
  alias TextWarfare.Game.Base

  @impl true
  def mount(params, session, socket) do
    new_socket =
      socket
      |> assign(:bases, list_bases())
      |> assign(
        :current_user,
        TextWarfare.Accounts.get_user_by_session_token(session["user_token"])
      )

    {:ok, new_socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Base")
    |> assign(:base, Game.get_base!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Base")
    |> assign(:base, %Base{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bases")
    |> assign(:base, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    base = Game.get_base!(id)
    {:ok, _} = Game.delete_base(base)

    {:noreply, assign(socket, :bases, list_bases())}
  end

  defp list_bases do
    Game.list_bases()
  end
end
