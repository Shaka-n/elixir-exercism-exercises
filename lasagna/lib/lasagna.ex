defmodule Lasagna do
  def expected_minutes_in_oven() do
    40
  end
 
  def remaining_minutes_in_oven(remaining) do
    Lasagna.expected_minutes_in_oven() - remaining
  end

  def preparation_time_in_minutes(layers) do
    layers * 2
  end

  def total_time_in_minutes(layers, cook_time) do
    Lasagna.preparation_time_in_minutes(layers) + cook_time
  end

  def alarm() do
    "Ding!"
  end
end
