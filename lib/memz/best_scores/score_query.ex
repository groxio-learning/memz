defmodule Memz.BestScores.ScoreQuery do
  import Ecto.Query, warn: false
  alias Memz.BestScores.Score

  def top_scores(limit) do
    from s in Score, 
    limit: ^limit, 
    select: {s.initials, s.score},
    order_by: [{:asc, :score}]
  end
end