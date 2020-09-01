defmodule Memz.Repo.Migrations.AddReadingIdToScores do
  use Ecto.Migration

  def change do
    alter table(:scores) do
      add :reading_id, references(:readings)
    end
  end
end
