defmodule MemzWeb.GameLive.Welcome do
  use MemzWeb, :live_view
  alias Memz.BestScores

  
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Memz.PubSub, "top scores")

    {:ok, get_scores(socket)}
  end
  
  def render(assigns) do
    ~L"""
    <h1>Memz it!</h1>
    <p>Tell us what you want to memorize, and how many steps you want to take, and we'll erase a few characters at a time for you.
    </p>
    <button phx-click="play">Play</button>
    
    <h2>Top Scores</h2>
    <table>
      <tr>
        <th>Score</th>
        <th>Initials</th>
      </tr>

      <%= for {initials, score} <- @top_scores do %>
        
        <tr>
          <td><%= score %></td>
          <td><%= initials %></td>
        </tr>
        
      <% end %>
    </table>
    """
  end
  
  defp get_scores(socket) do
    assign(socket, top_scores: BestScores.top_scores())
  end
  
  def handle_event("play", _meta, socket) do
    {:noreply, push_redirect(socket, to: "/game/play")}
  end
  
  def handle_info("score-changed-bad", socket) do
    {:noreply, get_scores(socket)}
  end
end