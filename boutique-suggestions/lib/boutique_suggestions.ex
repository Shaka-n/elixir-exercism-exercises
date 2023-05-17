defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    max_price = if options[:maximum_price] do options[:maximum_price] else 100 end
    for x <- tops,
      y <- bottoms,
      x.base_color != y.base_color,
      x.price + y.price < max_price do
      {x, y}
      end
  end
end
