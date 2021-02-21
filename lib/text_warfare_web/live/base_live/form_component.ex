defmodule TextWarfareWeb.BaseLive.FormComponent do
  use TextWarfareWeb, :live_component

  alias TextWarfare.Game

  require IEx

  @impl true
  def update(%{base: base} = assigns, socket) do
    changeset = Game.change_base(base)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"base" => base_params}, socket) do
    changeset =
      socket.assigns.base
      |> Game.change_base(base_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"base" => base_params}, socket) do
    save_base(socket, socket.assigns.action, base_params)
  end

  defp save_base(socket, :edit, base_params) do
    case Game.update_base(socket.assigns.base, base_params) do
      {:ok, _base} ->
        {:noreply,
         socket
         |> put_flash(:info, "Base updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_base(socket, :new, base_params) do
    base_params = Map.put(base_params, "user", socket.assigns.current_user)

    case Game.create_base(base_params) do
      {:ok, _base} ->
        {:noreply,
         socket
         |> put_flash(:info, "Base created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
