defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """

  defmodule Game do
    defstruct frames: [], score: 0, throw: 1
  end

  defmodule Frame do
    defstruct score: 0, bonuses: 0
  end

  @max_rolls 10 # maximum rolls count attribute

  @spec start() :: any
  def start do
    %Game{}
  end

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """

  @spec roll(any, integer) :: any | String.t()
  def roll(_game, roll) when roll < 0 do
    {:error, "Negative roll is invalid"}
  end

  def roll(_game, roll) when roll > @max_rolls do
    {:error, "Pin count exceeds pins on the lane"}
  end

  def roll(%Game{score: score}, roll) when score + roll > @max_rolls do
    {:error, "Pin count exceeds pins on the lane"}
  end

  # Fill ball
  def roll(%Game{frames: frames}, roll) when length(frames) >= @max_rolls do
    if bonuses_left?(frames) do
      score = if roll == @max_rolls, do: 0, else: roll
      %Game{frames: apply_bonuses(frames, roll), score: score}
    else
      {:error, "Cannot roll after game is over"}
    end
  end

  # Non-fill ball
  def roll(%Game{frames: frames} = game, roll) do
    do_roll(%Game{game | frames: apply_bonuses(frames, roll)}, roll)
  end

  # Strike
  defp do_roll(%Game{frames: frames, throw: 1}, @max_rolls) do
    %Game{frames: [%Frame{score: @max_rolls, bonuses: 2} | frames]}
  end

  # Spare
  defp do_roll(%Game{frames: frames, throw: 2, score: score}, roll) when score + roll == @max_rolls do
    %Game{frames: [%Frame{score: @max_rolls, bonuses: 1} | frames]}
  end

  # Normal first throw
  defp do_roll(%Game{frames: frames, throw: 1}, roll) do
    %Game{frames: frames, score: roll, throw: 2}
  end

  # Normal second throw
  defp do_roll(%Game{frames: frames, throw: 2, score: score}, roll) do
    %Game{frames: [%Frame{score: score + roll} | frames]}
  end

  defp apply_bonuses(frames, roll) do
    Enum.map(frames, fn
      %Frame{bonuses: 0} = frame ->
        frame

      %Frame{bonuses: bonuses, score: score} ->
        %Frame{bonuses: bonuses - 1, score: score + roll}
    end)
  end

  defp bonuses_left?(frames) do
    frames
    |> Enum.map(&Map.get(&1, :bonuses))
    |> Enum.any?(&(&1 > 0))
  end

 @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score(%Game{frames: frames}) do
    if length(frames) < @max_rolls or bonuses_left?(frames) do
      {:error, "Score cannot be taken until the end of the game"}
    else
      frames
      |> Enum.map(&Map.get(&1, :score))
      |> Enum.sum()
    end
  end
end
