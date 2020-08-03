defmodule MemzWeb.ReadingLive.FormComponent do
  use MemzWeb, :live_component

  alias Memz.Passages

  @impl true
  def update(%{reading: reading} = assigns, socket) do
    changeset = Passages.change_reading(reading)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"reading" => reading_params}, socket) do
    changeset =
      socket.assigns.reading
      |> Passages.change_reading(reading_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"reading" => reading_params}, socket) do
    save_reading(socket, socket.assigns.action, reading_params)
  end

  defp save_reading(socket, :edit, reading_params) do
    case Passages.update_reading(socket.assigns.reading, reading_params) do
      {:ok, _reading} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reading updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_reading(socket, :new, reading_params) do
    case Passages.create_reading(reading_params) do
      {:ok, _reading} ->
        {:noreply,
         socket
         |> put_flash(:info, "Reading created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
