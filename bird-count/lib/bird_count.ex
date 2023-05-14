defmodule BirdCount do
  def today([]), do: nil
  def today(list) do
    hd(list) 
  end

  def increment_day_count([]), do: [1]
  def increment_day_count(list) do
    [todays_count | previous_counts] = list
    [todays_count + 1 | previous_counts]
  end

  def has_day_without_birds?(list) do
    0 in list
  end

  def total([]), do: 0
  def total(list) do
    [count | tail] = list
    count + total(tail)
  end

  def busy_days([]), do: 0
  def busy_days(list) do
    [count | tail] = list
    if count >= 5 do
      1 + busy_days(tail)
    else
      busy_days(tail)
    end
  end
end
