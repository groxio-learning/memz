defmodule Memz.Repo.Migrations.AddUniqueConstraintToReadings do
  use Ecto.Migration

  def change do
    create unique_index(:readings, [:name])
  end
end
