defmodule BoutiqueInventory do
  def sort_by_price(inventory) do
    Enum.sort_by(inventory, &(&1.price))
  end

  def with_missing_price(inventory) do
    Enum.filter(inventory, &(&1.price == nil))
  end

  def update_names(inventory, old_word, new_word) do
    Enum.map(inventory, fn item -> %{item | name: String.replace(item.name, old_word, new_word)} end) 
  end

  def increase_quantity(%{quantity_by_size: quantity} = item, count) do
    quantity
    |> Enum.into(%{}, fn {k, v} -> {k, v + count} end)
    |> (&(%{item | quantity_by_size: &1})).()
  end

  def total_quantity(%{quantity_by_size: quantity} = _item) do
    Enum.reduce(quantity, 0, fn {_k, v}, acc -> v + acc end)
  end
end
