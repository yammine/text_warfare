defmodule TextWarfareWeb.BattleLive.FormComponent do
  use TextWarfareWeb, :live_component

  alias TextWarfare.Game

  @impl true
  def update(%{battle: battle} = assigns, socket) do
    changeset = Game.change_battle(battle)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"battle" => battle_params}, socket) do
    changeset =
      socket.assigns.battle
      |> Game.change_battle(battle_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"battle" => battle_params}, socket) do
    save_battle(socket, socket.assigns.action, battle_params)
  end

  defp save_battle(socket, :edit, battle_params) do
    case Game.update_battle(socket.assigns.battle, battle_params) do
      {:ok, _battle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Battle updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_battle(socket, :new, battle_params) do
    case Game.create_battle(battle_params) do
      {:ok, _battle} ->
        {:noreply,
         socket
         |> put_flash(:info, "Battle created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
