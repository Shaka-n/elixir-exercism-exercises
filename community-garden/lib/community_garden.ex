# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(_opts \\ []) do
    Agent.start(fn -> {0, []} end)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn {_, plot_list} -> plot_list end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn {counter, plot_list} -> 
      new_plot_id = counter + 1
      new_plot = %Plot{plot_id: new_plot_id, registered_to: register_to}
      {new_plot, {new_plot_id, [new_plot | plot_list]}} 
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn {counter, plot_list} ->
      new_plot_list = Enum.reject(plot_list, fn plot -> plot.plot_id == plot_id end )
      {counter, new_plot_list}
    end)
  end

  def get_registration(pid, plot_id) do
    Agent.get(pid, fn {_, plot_list} -> 
      case Enum.find(plot_list, fn p -> p.plot_id == plot_id end) do
        nil ->
          {:not_found, "plot is unregistered"}
        plot ->
          plot
      end
    end)
  end
end
