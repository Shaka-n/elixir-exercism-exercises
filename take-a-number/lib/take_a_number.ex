defmodule TakeANumber do

  def start() do
    {:ok, pid} = Task.start(fn -> loop(0) end)
    pid
  end

  defp loop(num) do
    receive do
      {:report_state, caller} ->
        send(caller, num)
        loop(num)
      {:take_a_number, caller} ->
        send(caller, num + 1)
        loop(num + 1)
      :stop ->
        nil
      _ ->
        loop(num)
    end
  end
end
