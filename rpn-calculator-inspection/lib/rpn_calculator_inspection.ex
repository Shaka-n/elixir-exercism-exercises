defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    pid = spawn_link(fn -> calculator.(input) end)
   %{pid: pid, input: input} 
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do

      receive do
        {:EXIT, ^pid, :normal} ->
          Map.put(results, input, :ok)
        {:EXIT, ^pid, _} ->
          Map.put(results, input, :error)
      after
        100 ->
          Map.put(results, input, :timeout) 
      end

  end

  def reliability_check(calculator, inputs) do
    trap_exit_state = Process.flag(:trap_exit, true)
    results = 
      inputs
      |> Enum.map(fn input-> 
        start_reliability_check(calculator, input) 
      end)
      |> Enum.reduce(%{}, fn check, acc -> 
        await_reliability_check_result(check, acc)
      end)

    Process.flag(:trap_exit, trap_exit_state)

    results
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(&Task.async(fn -> calculator.(&1)end))
    |> Enum.map(&Task.await(&1, 100))
  end
end
