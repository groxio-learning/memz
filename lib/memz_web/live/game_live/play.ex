defmodule MemzWeb.GameLive.Play do
  use MemzWeb, :live_view
  alias Memz.Game
  
  @default_text ""
  @default_steps 0
  
  def mount(_params, _session, socket) do
    {
      :ok, 
      assign(
        socket, 
        eraser: nil,
        changeset: Game.change_game(default_game(), %{}), 
        submitted: false
      )
    }
  end
    
  def render(%{eraser: nil}=assigns) do
    ~L"""
    <h1>What do you want to memorize?</h1>
    
    <%= f = form_for @changeset, "#",
      phx_change: "validate",
      phx_submit: "save" %>

      <%= label f, :steps %>
      <%= number_input f, :steps %>
      <%= error_tag f, :steps %>

      <%= label f, :text %>
      <%= text_input f, :text %>
      <%= error_tag f, :text %>

      <%= submit "Memorize", disabled: !@changeset.valid? %>
    </form>    
    """
  end
  
  def render(assigns) do
    ~L"""
    <h1>Memorize this much:</h1>
    <pre>
    <%= @eraser.text %>
    </pre>
    <button phx-click="erase">Erase some</button>
    """
  end
  
  defp default_game(), do: Game.new_game(@default_text, @default_steps)
  
  defp validate(socket, params) do
    assign(
      socket, 
      changeset: Game.change_game(Game.new_game("", 5), params)
    )
  end
  
  defp memorize(socket, params) do
    eraser = 
      default_game()
      |> Game.change_game(params)
      |> Game.create
    
    assign(socket, eraser: eraser)
  end
  
  defp erase(socket) do
    assign(socket, eraser: Game.erase(socket.assigns.eraser))
  end
  
  def handle_event("validate", %{"game" => params}, socket) do
    {:noreply, validate(socket, params)}
  end
  
  def handle_event("save", %{"game" => params}, socket) do
    {:noreply, memorize(socket, params)}
  end
  
  def handle_event("erase", _meta, socket) do
    {:noreply, erase(socket)}
  end

end