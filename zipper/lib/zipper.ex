defmodule Zipper do
  @type path ::
          :top
          | {:left, BT.t(), path}
          | {:right, BT.t(), path}


  @type t :: {BT.t(), path}

  @doc """
  Get a zipper focused on the root node.
  """
  @spec from_tree(BinTree.t()) :: Zipper.t()
  def from_tree(tree), do: {tree, :top}


  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Zipper.t()) :: BinTree.t()
  def to_tree({tree, :top}), do: tree


  def to_tree(zipper),  do: zipper |> up() |> to_tree()


  @doc """
  Get the value of the focus node.
  """
  @spec value(Zipper.t()) :: any
  def value({tree, _}), do: tree.value


  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Zipper.t()) :: Zipper.t() | nil
  def left({%{left: left}, _}) when is_nil(left) do
    nil
  end

  def left({tree, path}) do
    {tree.left, {:left, tree, path}}
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Zipper.t()) :: Zipper.t() | nil
  def right({%{right: right}, _}) when is_nil(right) do
    nil
  end

  def right({tree, path}) do
    {tree.right, {:right, tree, path}}
  end


  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Zipper.t()) :: Zipper.t() | nil
  def up({_, :top}), do: nil


  def up({_, {_, tree, path}}), do: {tree, path}


  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Zipper.t(), any) :: Zipper.t()
  def set_value({tree, path}, new_value) do
    tree = %{tree | value: new_value}
    {tree, update_parent_trees(path, tree)}
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_left({tree, path}, left) do
    updated_tree = %{tree | left: left}
    {updated_tree, update_parent_trees(path, updated_tree)}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Zipper.t(), BinTree.t() | nil) :: Zipper.t()
  def set_right({tree, path}, right) do
    updated_tree = %{tree | right: right}
    {updated_tree, update_parent_trees(path, updated_tree)}
  end

  defp update_parent_trees(:top, _), do: :top


  defp update_parent_trees({direction, tree, path}, subtree) do
    updated_tree = tree |> Map.put(direction, subtree)
    {direction, updated_tree, update_parent_trees(path, updated_tree)}
  end
end
