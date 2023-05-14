defmodule Rules do
  def eat_ghost?(power_pellet_active, touching_ghost) do
     power_pellet_active and touching_ghost
  end

  def score?(touching_power_pellet, touching_dot) do
    touching_power_pellet or touching_dot 
  end

  def lose?(power_pellet_active, touching_ghost) do
    case {power_pellet_active, touching_ghost} do
      {false, true} ->
        true
      _ ->
        false
    end
  end

  def win?(has_eaten_all_dots, power_pellet_active, touching_ghost) do
    if has_eaten_all_dots and !lose?(power_pellet_active, touching_ghost) do
      true
    else
      false
      end
  end
end
