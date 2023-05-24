defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """
  use GenServer
  @doc """
  Initializes buffer with max capacity, a read index,
  a write index, and a data store.
  """
  @impl true
  def init(capacity) do
    {:ok, %{cap: capacity, next_read: 1, next_write: 1, slots: capacity, store: init_store(capacity)}} 
  end

  defp init_store(capacity) do
    Enum.reduce(1..capacity, %{}, fn x, acc -> Map.put(acc, x, nil) end)
  end

  @impl true
  def handle_call(:read, _from, %{next_read: next_read, store: store} = state) do
    case store[next_read] do
      nil ->
        {:reply, {:error, :empty}, state}
      value ->
        {:reply, {:ok, value}, update_read(state)}
    end
  end


  @impl true
  def handle_call({:write, item}, _from, %{slots: slots} = state) do
    if slots == 0 do
      {:reply, {:error, :full}, state}
    else
      {:reply, :ok, update_write(state, item)}
    end
  end

  @impl true
  def handle_call({:overwrite, item}, _from, %{slots: slots} = state) do
    if slots == 0 do
      {:reply, :ok, update_overwrite(state, item)}
    else
      {:reply, :ok, update_write(state, item)}
    end
  end

  @impl true
  def handle_cast(:clear, state), do: {:noreply, %{state | next_read: 1, next_write: 1, slots: state.cap, store: init_store(state.cap)}} 

  defp update_read(%{cap: cap,
    next_read: current_next_read,
    slots: slots,
    store: store} = state) 
  do
      if current_next_read == cap do
      %{state | next_read: 1, slots: slots + 1, store: %{store | current_next_read => nil}}
    else
      %{state | next_read: current_next_read + 1, slots: + 1, store: %{store | current_next_read => nil}}
    end
  end

  defp update_write(%{cap: cap, next_write: next_write, slots: slots, store: store} = state, item) do
    if next_write == cap do
      %{state | next_write: 1, slots: slots - 1, store: %{ store | next_write => item}}
    else
      %{state | next_write: next_write + 1, slots: slots - 1, store: %{store | next_write => item}}
    end
  end

  defp update_overwrite(%{cap: cap, next_write: next_write, store: store, next_read: next_read}= state, item)do
    incoming_next_read = if next_read + 1 > cap, do: 1, else: next_read + 1
    if next_write == cap do
      %{state | next_read: incoming_next_read, next_write: 1, store: %{ store | next_write => item}}
    else
      %{state | next_read: incoming_next_read, next_write: next_write + 1, store: %{store | next_write => item}}
    end
  end


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
