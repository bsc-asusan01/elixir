defmodule Year do
  @doc """
  Returns whether 'year' is a leap year.

  A leap year occurs:

  on every year that is evenly divisible by 4
    except every year that is evenly divisible by 100
      unless the year is also evenly divisible by 400
  """
  @spec leap_year?(non_neg_integer) :: boolean
  def leap_year?(year) do

    case { rem(year,4), rem(year,100), rem(year,400) }  do
      {0,0,0} -> true
      {0,0,_} -> false
      {0,_,_} -> true
      _       -> false
    end

  end

  # def leap_year?(year) when rem(year, 400) == 0, do: true
  # def leap_year?(year) when rem(year, 100) == 0, do: false
  # def leap_year?(year) when rem(year, 4) == 0, do: true
  # def leap_year?(_), do: false


  # def leap_year?(year) do
    # rem(year,4) == 0 and
    #   (not (rem(year,100) == 0) or rem(year,400) == 0)

  # end
end
