defmodule RPNCalculator.Exception do
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end
  
  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] ->
          %StackUnderflowError{message: "stack underflow occurred"}
        _->
          %StackUnderflowError{message: "stack underflow occurred, context: #{value}"}
      end
    end
  end

  def divide(stack) when length(stack) != 2, do: raise StackUnderflowError, "when dividing"
  def divide([0, _num]), do: raise DivisionByZeroError
  def divide(stack), do: List.last(stack) / List.first(stack)
end
