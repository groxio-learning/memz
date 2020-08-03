defmodule MemzWeb.GameLive.Welcome do
  use MemzWeb, :live_view
  alias Memz.{BestScores, Passages}

  
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Memz.PubSub, "top scores")

    {
      :ok, 
      socket
      |> get_scores
      |> get_initial_passage
    }
  end
  
  def render(assigns) do
    ~L"""
    <h1>Memz it!</h1>
    <p>Tell us what you want to memorize, and how many steps you want to take, and we'll erase a few characters at a time for you.
    </p>
    
    
    <h2>
      What do you want to memorize?
      <br/>
      <button phx-click="next_passage">&larr;</button> 
      <%= @passage_name %> 
      <button phx-click="previous_passage">&rarr;</button>
      <br/>
      <hr>
      <%= if @reading do %>
        <pre><%= @reading.passage %></pre>
        <h3>How much can you memorize in <%= @reading.steps %> steps?<h3>
        <button phx-click="play" phx-value-reading="<%= @passage_name %>">Go</button>
      <% end %>
    </h2>
    
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
  
  defp get_initial_passage(socket) do
    reading = Passages.get_first_reading()
    assign(socket, reading: reading, passage_name: maybe_passage_name(reading))
  end
  
  defp maybe_passage_name(nil), do: nil
  defp maybe_passage_name(reading), do: reading.name
  
  defp next_passage(socket) do
    new_passage_name = Passages.next_passage(socket.assigns.passage_name)
    
    assign(socket, passage_name: new_passage_name)
  end
  
  defp previous_passage(socket) do
    new_passage_name = Passages.previous_passage(socket.assigns.passage_name)
    
    assign(socket, passage_name: new_passage_name)
  end
  
  defp lookup_reading(socket) do
    assign(socket, reading: Passages.lookup_reading(socket.assigns.passage_name))
  end

  def handle_event("play", _meta, socket) do
    {:noreply, push_redirect(socket, to: "/game/play")}
  end
  def handle_event("next_passage", _meta, socket) do
    {:noreply, socket |> next_passage |> lookup_reading}
  end
  def handle_event("previous_passage", _meta, socket) do
    {:noreply, socket |> previous_passage |> lookup_reading}
  end
  
  def handle_info("score-changed-bad", socket) do
    {:noreply, get_scores(socket)}
  end
end