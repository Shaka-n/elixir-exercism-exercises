defmodule LibraryFees do
  def datetime_from_string(string) do
    NaiveDateTime.from_iso8601!(string)
  end

  def before_noon?(datetime) do
    time = NaiveDateTime.to_time(datetime)

    case Time.compare(time, ~T[12:00:00]) do
      :lt ->
        true
      _ ->
        false
    end
  end

  def return_date(checkout_datetime) do
    if before_noon?(checkout_datetime) do
      checkout_datetime
      |> NaiveDateTime.to_date()
      |> Date.add(28)
    else
      checkout_datetime
      |> NaiveDateTime.to_date()
      |> Date.add(29)
    end
  end

  def days_late(planned_return_date, actual_return_datetime) do
    diff = 
      actual_return_datetime
      |> NaiveDateTime.to_date()
      |> Date.diff(planned_return_date)
    if diff <= 0 do
      0
    else
      diff
    end
  end

  def monday?(datetime) do
    first_day = 
    datetime
    |> NaiveDateTime.to_date()
    |> Date.beginning_of_week()

    case Date.compare(NaiveDateTime.to_date(datetime), first_day) do
      :gt ->
        false
      _ ->
        true
    end

  end

  def calculate_late_fee(checkout, return, rate) do
    actual_return_date = datetime_from_string(return)
    
    checkout
    |> datetime_from_string()
    |> return_date()
    |> days_late(actual_return_date)
    |> (fn days -> days * rate end).()
    |> (fn fee -> if monday?(actual_return_date), do: floor(fee/2), else: fee end).()
  end
end
