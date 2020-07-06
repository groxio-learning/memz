defmodule MemzWeb.GameLive.Welcome do
  use MemzWeb, :live_view
  
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
  
  def render(assigns) do
    ~L"""
    <h1>Memz it!</h1>
    <p>Tell us what you want to memorize, and how many steps you want to take, and we'll erase a few characters at a time for you.
    </p>
    <button phx-click="play">Play</button>
    """
  end
  
  def handle_event("play", _meta, socket) do
    {:noreply, push_redirect(socket, to: "/game/play")}
  end
end