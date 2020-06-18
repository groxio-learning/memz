defmodule Memz.Game.Eraser do
  defstruct ~w[schedule text]a
  @delete_proof ["\n", ",", "."]
  
  def new(text, steps) do
    %__MODULE__{text: text, schedule: schedule(text, steps)}
  end
  
  def erase(%{schedule: [to_erase|rest], text: text}) do
    erased = 
      text
      |> String.graphemes
      |> Enum.with_index(1)
      |> Enum.map(fn {char, index} -> maybe_erase(char, index in to_erase) end)
      |> Enum.join("")
    
    %__MODULE__{schedule: rest, text: erased}
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
end