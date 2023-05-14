defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  def new() do
    %RemoteControlCar{nickname: "none"}
  end

  def new(nickname) do
    %RemoteControlCar{nickname: nickname}
  end

  def display_distance(%RemoteControlCar{distance_driven_in_meters: distance} = _remote_car) do
    "#{distance} meters"
  end

  def display_battery(%RemoteControlCar{battery_percentage: battery} = _remote_car) do
    if battery == 0, do: "Battery empty", else: "Battery at #{battery}%"
  end

  def drive(%RemoteControlCar{battery_percentage: 0} = remote_car), do: remote_car

  def drive(%RemoteControlCar{battery_percentage: battery, distance_driven_in_meters: distance} = remote_car) do
      %{remote_car | battery_percentage: battery - 1, distance_driven_in_meters: distance + 20}
  end

end
