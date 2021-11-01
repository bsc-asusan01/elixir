defmodule Knapsack do

  @typedoc """
  Item in knapsack
  """
  @type item :: %{value: integer, weight: integer}

  @doc """
  Return the maximum value that a knapsack can carry.
  Brute force, no tail recursion
  """
  @spec maximum_value(items :: [item()], remaining_capacity :: integer) ::
          integer
  def maximum_value([], _remaining_capacity), do: 0

  def maximum_value([%{weight: w} | rest], remaining_capacity) when w > remaining_capacity do
    maximum_value(rest, remaining_capacity)
  end

  def maximum_value([%{weight: w, value: v} | rest], remaining_capacity) do
    pick_item = v + maximum_value(rest, remaining_capacity - w)
    drop_item = maximum_value(rest, remaining_capacity)

    max(pick_item, drop_item)
  end
end
