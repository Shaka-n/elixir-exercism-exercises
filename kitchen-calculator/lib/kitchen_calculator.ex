defmodule KitchenCalculator do
  @conversion_chart %{milliliter: 1, cup: 240, fluid_ounce: 30, teaspoon: 5, tablespoon: 15}

  def get_volume({_name, quantity}) do
    quantity
  end

  def to_milliliter({name, quantity}) do
    {:milliliter, @conversion_chart[name] * quantity}
  end

  def from_milliliter({_name, quantity}, unit) do
    {unit, quantity / @conversion_chart[unit]}
  end

  def convert(volume_pair, unit) do
      volume_pair
      |> to_milliliter()
      |> from_milliliter(unit)
  end
end
