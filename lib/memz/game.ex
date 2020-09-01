defmodule Memz.Game do
  alias Ecto.Changeset
  alias Memz.Game.Eraser
  @field_types %{text: :string, steps: :integer}
  defstruct [:text, :steps]
  
  def new_game(text, steps) do
    __struct__(text: text, steps: steps)
  end
  
  def new_eraser(text, steps) do
    Eraser.new(text, steps)
  end
  
  def create(%{valid?: true}=changeset) do
    Eraser.new(changeset.changes.text, changeset.changes.steps)
  end
  def create(changeset), do: changeset
  
  def change_game(game, params) do
    {game, @field_types}
    |> Changeset.cast(params, Map.keys(@field_types))
    |> Changeset.validate_required([:text, :steps])
    |> Changeset.validate_length(:text, min: 4)
    |> Map.put(:action, :validate)
  end
  
  def guess_changeset() do
    {%{}, %{text: :string}}
    |> Changeset.cast(%{}, [:text])
  end
  
  def erase(eraser) do
    Eraser.erase(eraser)
  end
  
  def score(eraser, guess) do
    Eraser.score(eraser, guess)
  end
  
  def done?(eraser) do
    eraser.status == :finished
  end
end