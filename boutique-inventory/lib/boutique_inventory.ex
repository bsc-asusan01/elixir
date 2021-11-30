defmodule BoutiqueInventory do
  def sort_by_price(inventory), do:
    Enum.sort_by(inventory, &(&1.price))

  def with_missing_price(inventory), do:
    Enum.filter(inventory, &(&1.price == nil))
    |> sort_by_price


  def increase_quantity(item, count) do
    qty_by_size =
      Enum.into(item.quantity_by_size, %{}, fn {size, qty} -> {size, qty + count} end)

      %{item | quantity_by_size: qty_by_size}
  end

  def total_quantity(item) do
    Enum.reduce(item.quantity_by_size, 0, fn {_size, quantity}, acc -> quantity + acc end)
  end
end
