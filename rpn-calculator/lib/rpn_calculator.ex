defmodule RPNCalculator do
  def calculate!(stack, operation) do
    operation.(stack)
  end

  def calculate(stack, operation) do
    try do
      {:ok, operation.(stack)}
    rescue
      _e in _ -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      {:ok, operation.(stack)}
    rescue
      e in _ -> {:error, Exception.message(e)}
    end
  end
end
