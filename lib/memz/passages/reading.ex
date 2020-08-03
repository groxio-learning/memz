defmodule Memz.Passages.Reading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readings" do
    field :name, :string
    field :passage, :string
    field :steps, :integer

    timestamps()
  end

  @doc false
  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [:name, :passage, :steps])
    |> validate_required([:name, :passage, :steps])
    |> unique_constraint(:name)
    |> validate_length(:passage, min: 4)
    |> validate_number(:steps, greater_than: 2)
  end
end
