defmodule WineCellar do
  def explain_colors do
    wines = [
      white: "Fermented without skin contact.",
      red: "Fermented with skin contact using dark-colored grapes.",
      rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
    ]
    wines
  end

  def filter(cellar, color, opts \\ []) do
    # year, country = opts[:year], opts[:country]
    wines = Keyword.get_values(cellar, color)
    wines =
      case Keyword.get(opts, :year) do
        nil -> wines
        year -> filter_by_year(wines, year)
      end
    wines =
      case Keyword.get(opts, :country) do
        nil -> wines
        country -> filter_by_country(wines, country)
      end
    wines
  end

  # The functions below do not need to be modified.

  defp filter_by_year(wines, year)
  defp filter_by_year([], _year), do: []

  defp filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  defp filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  defp filter_by_country(wines, country)
  defp filter_by_country([], _country), do: []

  defp filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  defp filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
