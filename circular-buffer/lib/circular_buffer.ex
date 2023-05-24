defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """
  use GenServer
  @impl true
  def init(capacity) do
    {:ok, {capacity, []}}
  end
  @impl true
  def handle_call(:read, _from, state) do
    case state do
      {_capacity, []} ->
        {:reply, {:error, :empty}, []}
      {capacity, [oldest | tail]} ->
        {:reply, {:ok, oldest}, {capacity, tail}}
    end
  end
  @impl true
  def handle_call({:write, item}, _from, {capacity, list} = _state) do
    if length(list) == capacity do
        {:reply, {:error, :full}, list}
    else
      {:reply, :ok, {capacity, insert(list, item)}}
    end
  end
  @impl true
  def handle_call({:overwrite, item}, _from, {capacity, [ _head | tail] = list} = _state) do
    if length(list) == capacity do
      {:reply, :ok, {capacity, insert(tail, item)}}
    else
      {:reply, :ok, {capacity, insert(list, item)}}
    end
  end
  defp insert([], item), do: [item]
  defp insert([head | []], item), do: [head| [item | []]]
  defp insert( [head | tail] = _list, item), do: [head | insert(tail, item)]
  @impl true
  def handle_cast(:clear, {capacity, _list} = _state), do: {:noreply, {capacity, []}}
  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start_link(CircularBuffer, capacity)
  end
  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read)
  end
  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    GenServer.call(buffer, {:write, item})
  end
  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    GenServer.call(buffer, {:overwrite, item})
  end
  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.cast(buffer, :clear)
  end
end
