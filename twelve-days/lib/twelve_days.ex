defmodule TwelveDays do

  @days %{
    1  => %{ sequentia: "first",    gift: "a Partridge in a Pear Tree." },
    2  => %{ sequentia: "second",   gift: "two Turtle Doves, and " },
    3  => %{ sequentia: "third",    gift: "three French Hens, " },
    4  => %{ sequentia: "fourth",   gift: "four Calling Birds, " },
    5  => %{ sequentia: "fifth",    gift: "five Gold Rings, " },
    6  => %{ sequentia: "sixth",    gift: "six Geese-a-Laying, " },
    7  => %{ sequentia: "seventh",  gift: "seven Swans-a-Swimming, " },
    8  => %{ sequentia: "eighth",   gift: "eight Maids-a-Milking, " },
    9  => %{ sequentia: "ninth",    gift: "nine Ladies Dancing, " },
    10 => %{ sequentia: "tenth",    gift: "ten Lords-a-Leaping, " },
    11 => %{ sequentia: "eleventh", gift: "eleven Pipers Piping, " },
    12 => %{ sequentia: "twelfth",  gift: "twelve Drummers Drumming, " }
  }

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(number) do
    "On the #{@days[number].sequentia} day of Christmas my true love gave to me: #{gifts(number)}"
  end

  defp gifts(0), do: ""
  defp gifts(n), do: @days[n].gift <> gifts(n - 1)

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    Enum.map_join(starting_verse..ending_verse, "\n", &verse/1)
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing, do: verses(1, 12)

end
