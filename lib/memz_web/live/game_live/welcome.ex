defmodule MemzWeb.GameLive.Welcome do
  use MemzWeb, :live_view
  alias Memz.Game
  
  def mount(_params, _session, socket) do
    {
      :ok, 
      assign(
        socket, 
        changeset: Game.change_game(Game.new_game("", 5), %{}), 
        submitted: false
      )
    }
  end
  
  def render(assigns) do
    ~L"""
    <h1>What do you want to memorize?</h1>
    <pre>
    <%= inspect @changeset %>
    </pre>
    
    <%= f = form_for @changeset, "#",
      phx_change: "validate",
      phx_submit: "save" %>

      <%= label f, :steps %>
      <%= number_input f, :steps %>
      <%= error_tag f, :steps %>

      <%= label f, :text %>
      <%= text_input f, :text %>
      <%= error_tag f, :text %>

      <%= submit "Memorize", phx_disable_with: "Saving..." %>
    </form>    
    <pre><%= @submitted %></pre>
    """
  end
  
  defp validate(socket, params) do
    assign(
      socket, 
      changeset: Game.change_game(Game.new_game("", 5), params)
    )
  end
  
  defp memorize(socket, params) do
    assign(socket, submitted: true)
  end
  
  def handle_event("validate", %{"game" => params}, socket) do
    {:noreply, validate(socket, params)}
  end
  
  def handle_event("save", %{"game" => params}, socket) do
    {:noreply, memorize(socket, params)}
  end

end