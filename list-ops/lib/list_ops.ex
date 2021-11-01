defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    foldl(l, 0, fn(_, acc) -> acc + 1 end)
  end

  @spec reverse(list) :: list
  def reverse(l) do
    foldl(l, [], &([&1 | &2]))
  end

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    foldl(l, [], &([f.(&1) | &2])) |> reverse
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    l
    |> reverse
    |> foldl( [], &(if f.(&1), do: [&1| &2], else: &2) )
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([h | t], acc, f) do
    reduce(t, f.(h,acc), f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    reverse(a)
    |> foldl(b, &([&1 | &2]))
  end

  @spec concat([[any]]) :: [any]
  def concat(list) do
    list
    |> reverse
    |> foldl([], &append/2)
  end

  @spec foldl(list, acc, ((any, acc) -> acc)) :: acc
  def foldl([], acc, _), do: acc
  def foldl([h | t], acc, f) do
    foldl(t, f.(h,acc), f)
  end

  @spec foldr(list, acc, ((any, acc) -> acc)) :: acc
  def foldr([], acc, _), do: acc
  def foldr([h | t], acc, f) do
    f.(h, foldr(t, acc, f))
  end
end
