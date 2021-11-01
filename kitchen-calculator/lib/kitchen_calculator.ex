defmodule KitchenCalculator do
  def get_volume(volume_pair), do: elem(volume_pair, 1)

  def to_milliliter({unit, volume}), do: {:milliliter, volume * conversion_table(unit)}

  defp conversion_table(:cup), do: 240
  defp conversion_table(:fluid_ounce), do: 30
  defp conversion_table(:teaspoon), do: 5
  defp conversion_table(:tablespoon), do: 15
  defp conversion_table(:milliliter), do: 1

  def from_milliliter({from_unit, volume}, to_unit) do
    {to_unit, volume / conversion_table(to_unit)}
  end

  def convert(volume_pair, to_unit) do
    volume_pair # teaspoon 9 , 5 * 9 = 45 / 15
    |> to_milliliter()
    |> from_milliliter(to_unit)
  end
end
