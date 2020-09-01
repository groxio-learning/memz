defmodule MemzWeb.GameLive.Play do
  use MemzWeb, :live_view
  alias Memz.{Game, BestScores, Passages}
  alias Memz.BestScores.Score
  
  @default_text ""
  @default_steps 0
  
  def mount(_params, _session, %{assigns: %{live_action: :over}}=socket) do
    {:ok, push_redirect(socket, to: "/game/welcome")}
  end
  
  def mount(params, _session, socket) do
    {
      :ok, 
      assign(
        socket, 
        guess_changeset: Game.guess_changeset(),
        changeset: Game.change_game(default_game(), %{}), 
        submitted: false
      )
      |> new_eraser(params["passage_name"])
    }
  end
    
  def render(%{live_action: :over}=assigns) do
    ~L"""
    <h1>Game over!</h1>
    <h2>Your score: <%= @eraser.score %></h2>
    <h2>Enter your initials!</h2>
    <%= f = form_for @score_changeset, "#",
      phx_change: "validate_score",
      phx_submit: "save_score" %>

      <%= label f, :score %>
      <%= number_input f, :score, disabled: true %>
      <%= error_tag f, :score %>

      <%= label f, :initials %>
      <%= text_input f, :initials %>
      <%= error_tag f, :initials %>

      <%= submit "Submit Score", disabled: !@score_changeset.valid? %>
    </form>    
    <button phx-click="play">Play again?</button>
    """
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
  
  def render(%{eraser: %{status: :erasing}}=assigns) do
    ~L"""
    <h1>Memorize this much:</h1>
    <pre>
    <%= @eraser.text %>
    </pre>
    <button phx-click="erase">Erase some</button>
    
    <%= score(@eraser) %>
    """
  end

  def render(%{eraser: %{status: :guessing}}=assigns) do
    ~L"""
    <h1>Type the text, filling in the blanks!</h1>
    <pre>
      <%= @eraser.text %>
    </pre>

    <pre>
    <%= f = form_for @guess_changeset, "#",
      phx_submit: "guess", as: "guess" %>

      <%= label f, :text %>
      <%= textarea f, :text %>
      <%= error_tag f, :text %>

      <%= submit "Type the text" %>
    </form>    

    """
  end
  
  def render(%{eraser: %{status: :finished}}=assigns) do
    ~L"""
    <h1>Nice job! See how you did: </h1>
    <pre>
      <%= score(@eraser) %>
    </pre>
    """
  end
  
  defp score(eraser) do
    """
    <h2>Your score so far (lower is better): #{eraser.score}</h2>
    """
    |> Phoenix.HTML.raw
  end
  
  defp default_game(), do: Game.new_game(@default_text, @default_steps)
  
  defp new_eraser(socket, passage_name) do
    reading = Passages.lookup_reading(passage_name)
    eraser = Game.new_eraser(reading.passage, reading.steps)
    
    assign(
      socket, 
      eraser: eraser, 
      reading: reading
    )
  end
  
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
  
  defp score(socket, guess) do
    assign(socket, eraser: Game.score(socket.assigns.eraser, guess))
  end
  
  defp save_score(socket, params) do
    BestScores.create_score(socket.assigns.reading, params["initials"], socket.assigns.eraser.score)
    push_redirect(socket, to: "/game/welcome")
  end
  
  defp validate_score(socket, params) do
    changeset = 
      %Score{score: socket.assigns.eraser.score}
      |> BestScores.change_score(params)
      |> Map.put(:action, :validate)
      
    assign(
      socket, 
      score_changeset: changeset
    )
  end
  
  defp maybe_finish(%{assigns: %{eraser: %{status: :finished, score: score}}}=socket) do
    socket
    |> assign(score_changeset: BestScores.change_score(%Score{score: score}, %{}))
    |> push_patch(to: "/game/over")
  end
  defp maybe_finish(socket), do: socket
  
  def handle_event("validate", %{"game" => params}, socket) do
    {:noreply, validate(socket, params)}
  end
  
  def handle_event("save", %{"game" => params}, socket) do
    {:noreply, memorize(socket, params)}
  end
  
  def handle_event("erase", _meta, socket) do
    {:noreply, erase(socket)}
  end
  
  def handle_event("guess", %{"guess" => %{"text" => guess}}, socket) do
    {:noreply, socket |> score(guess) |> maybe_finish}
  end
  
  def handle_event("validate_score", %{"score" => params}, socket) do
    {:noreply, validate_score(socket, params)}
  end

  def handle_event("save_score", %{"score" => params}, socket) do
    {:noreply, save_score(socket, params)}
  end
  
  def handle_params(_params, _, socket) do
    {:noreply, socket}
  end
end