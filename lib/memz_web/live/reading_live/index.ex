defmodule MemzWeb.ReadingLive.Index do
  use MemzWeb, :live_view

  alias Memz.Passages
  alias Memz.Passages.Reading

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :readings, list_readings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Reading")
    |> assign(:reading, Passages.get_reading!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Reading")
    |> assign(:reading, %Reading{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Readings")
    |> assign(:reading, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    reading = Passages.get_reading!(id)
    {:ok, _} = Passages.delete_reading(reading)

    {:noreply, assign(socket, :readings, list_readings())}
  end

  defp list_readings do
    Passages.list_readings()
  end
end
