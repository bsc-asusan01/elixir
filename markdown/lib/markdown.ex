defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(m) do
    # patch(Enum.join(Enum.map(String.split(m, "\n"), fn t -> process(t) end)))
    m
    |> String.split("\n")
    |> Enum.map_join(&process_items/1)
    |> process_tags
    |> close_ul
  end

  defp process_items("#" <> txt), do: txt |> parse_header(1)
  defp process_items("* " <> txt), do: "<li>#{txt}</li>"
  defp process_items(txt), do: "<p>#{txt}</p>"

  defp parse_header(" " <> txt, lval), do: "<h#{lval}>#{txt}</h#{lval}>"
  defp parse_header("#" <> txt, lval), do: parse_header(txt, lval + 1)

  defp process_tags(txt) do
    txt
    |> String.replace(~r/__(.*)__/, "<strong>\\1</strong>")
    |> String.replace(~r/_(.*)_/, "<em>\\1</em>")
  end

  defp close_ul(txt) do
    txt
    |> String.replace("<li>","<ul><li>", global: false)
    |> String.replace_suffix("</li>", "</li></ul>")
  end

end
