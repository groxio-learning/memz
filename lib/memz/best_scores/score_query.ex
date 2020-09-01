defmodule Memz.BestScores.ScoreQuery do
  import Ecto.Query, warn: false
  alias Memz.BestScores.Score

  def top_scores(limit, reading_id) do
    from s in Score, 
    where: s.reading_id == ^reading_id,
    limit: ^limit, 
    select: {s.initials, s.score},
    order_by: [{:asc, :score}]
  end
end