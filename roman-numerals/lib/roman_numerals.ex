defmodule RomanNumerals do
  @doc """
  Convert the number to a roman number.
  """
  @romanlist [
    {1000, "M"},
    {900, "CM"},
    {500, "D"},
    {400, "CD"},
    {100, "C"},
    {90, "XC"},
    {50, "L"},
    {40, "XL"},
    {10, "X"},
    {9, "IX"},
    {5, "V"},
    {4, "IV"},
    {1, "I"}
  ]

  @spec numeral(pos_integer) :: String.t()
  def numeral(0) do "" end
  def numeral(number) do
    {num, rom} = Enum.find(@romanlist, fn {num, rom} ->
      number >= num
    end)
    # Recursive / repeat e.g
    # 621 : DCXXI. 21 - 10, then 11 - 10 thus 2 X's
    rom <> numeral(number - num)
  end
end
