defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> alpha_only
    |> String.downcase()
    |> String.split()
    |> map_list
  end

  defp alpha_only(sentence) do
    String.replace(sentence, ~r/[^[:alnum:]-]/u," ")
  end

  defp map_list(word_list) do
    Enum.reduce(word_list, Map.new(), &(count_word/2))
  end

  defp count_word(word, map) do
    Map.update(map,word,1, &(&1 + 1))
  end
end
