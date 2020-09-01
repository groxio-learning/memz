defmodule Memz.BestScores.Score do
  use Ecto.Schema
  import Ecto.Changeset
  alias Memz.Passages.Reading

  schema "scores" do
    field :initials, :string
    field :score, :integer
    
    belongs_to :reading, Reading
    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:initials, :score])
    |> validate_required([:initials, :score])
    |> validate_length(:initials, min: 3, max: 3)
  end
end
