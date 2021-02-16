defmodule BeerSongInitial do
  @doc """
  Get a single verse of the beer song
      assert BeerSong.verse(2) ==
        2 bottles of beer on the wall, 2 bottles of beer.
        Take one down and pass it around, 1 bottle of beer on the wall.

      assert BeerSong.verse(1) ==
        1 bottle of beer on the wall, 1 bottle of beer.
        Take it down and pass it around, no more bottles of beer on the wall.

        assert BeerSong.verse(0) ==
        No more bottles of beer on the wall, no more bottles of beer.
        Go to the store and buy some more, 99 bottles of beer on the wall.
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    { current_bottles, take_bottles } = beer_phrase(number)
    { remaining_bottles, _ } = beer_phrase(number - 1)
    """
    #{String.capitalize(current_bottles)} of beer on the wall, #{current_bottles} of beer.
    #{take_bottles}, #{remaining_bottles} of beer on the wall.
    """
  end

  def beer_phrase(n) do
    cond do
      n > 1 -> { "#{n} bottles", "Take one down and pass it around" }
      n == 1 -> { "1 bottle", "Take it down and pass it around"}
      n < 0 -> { "99 bottles", ""}
      true -> { "no more bottles", "Go to the store and buy some more"}
    end
  end

  @doc """
  Get the entire beer song for a given range of numbers of bottles.

    assert BeerSong.lyrics(2..0) ==
      2 bottles of beer on the wall, 2 bottles of beer.
      Take one down and pass it around, 1 bottle of beer on the wall.

      1 bottle of beer on the wall, 1 bottle of beer.
      Take it down and pass it around, no more bottles of beer on the wall.

      No more bottles of beer on the wall, no more bottles of beer.
      Go to the store and buy some more, 99 bottles of beer on the wall.
  """
  @spec lyrics(Range.t()) :: String.t()
  def lyrics(range \\ 99..0) do
    range |> Enum.map_join( "\n", &(verse/1) )  #  &(verse(&1)), &verse/1
  end
end
