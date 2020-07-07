defmodule Memz.Game.Eraser do
  
  # finished, guessing, erasing
  defstruct ~w[schedule text score initial_text status]a
  @delete_proof ["\n", ",", "."]
  
  def new(text, steps) do
    %__MODULE__{
      text: text, 
      schedule: schedule(text, steps), 
      score: 0, 
      initial_text: text, 
      status: :erasing
    }
  end
  
  def erase(%{schedule: [to_erase|rest], text: text}=eraser) do
    erased = 
      text
      |> String.graphemes
      |> Enum.with_index(1)
      |> Enum.map(fn {char, index} -> maybe_erase(char, index in to_erase) end)
      |> Enum.join("")
    
    
    %{eraser|schedule: rest, text: erased, status: :guessing}
  end
  
  def score(eraser, guess) do
    compute_score(eraser, eraser.initial_text, guess)
    |> set_next_status
  end
  
  defp set_next_status(%{schedule: []}=eraser) do
    %{eraser| status: :finished}
  end
  defp set_next_status(eraser) do
    %{eraser| status: :erasing}
  end

  defp compute_score(eraser, actual, guess) do
    score_difference = 
      actual
      |> String.myers_difference(guess) 
      |> Enum.reject(fn {edit, _} -> edit == :eq end)
      |> Enum.map(fn {_edit, string} -> string end)
      |> Enum.join
      |> String.length
    
    %{eraser | score: eraser.score + score_difference}
  end
  
  defp maybe_erase(char, _test) when char in @delete_proof, do: char
  defp maybe_erase(_char, true), do: "_"
  defp maybe_erase(char, _false), do: char
  
  defp schedule(text, steps) do
    size = String.length(text)
    chunk_size = 
      size
      |> Kernel./(steps)
      |> ceil
    
    (1..size)
    |> Enum.shuffle
    |> Enum.chunk_every(chunk_size)
  end
  
  def done?(%{steps: []}), do: true
  def done?(_eraser), do: false
end