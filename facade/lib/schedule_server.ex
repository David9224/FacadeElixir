defmodule ScheduleServer do
  use GenServer

  @name :bit_facade

  def start_link(initial_value \\ 0) do
    GenServer.start_link(__MODULE__, initial_value, name: @name)
  end

  def init(state), do: {:ok, state}

  def read_system_config_file(subject) do
    GenServer.cast(subject, {:read_system, self()})
  end

  def initial(subject) do
    GenServer.cast(subject, {:initial, self()})
  end

  def initial_context(subject) do
    GenServer.cast(subject, {:initial_context, self()})
  end

  def destroy(subject) do
    GenServer.cast(subject, {:destroy, self()})
  end

  def shutdown(subject) do
    GenServer.cast(subject, :shut_down)
  end

  def read(subject), do: GenServer.call(subject, :read)

  def handle_cast({:read_system, observer_pid}, state) do
    read_system_config_file()
    state = :read_system_config_file
    {:noreply, state}
  end

  def handle_cast({:initial, observer_pid}, state) do
    initial()
    state = :initial
    {:noreply, state}
  end

  def handle_cast({:initial_context, observer_pid}, state) do
    initial_context()
    state = :initial_context
    {:noreply, state}
  end

  def handle_cast({:destroy, observer_pid}, state) do
    destroy()
    state = :destroy
    {:noreply, state}
  end

  def handle_cast(:shut_down, state) do
    shutdown()
    state = :shutdown
    {:noreply, state}
  end

  def handle_call(:read, _from_id, state) do
    {:reply, state, state}
  end

  defp read_system_config_file() do
    IO.puts("Reading system config files...")
    try do
      :timer.sleep(1000)
      IO.puts("Config files Ok!")
    rescue
      _ -> IO.puts("Error")
    end
  end

  defp initial() do
    IO.puts("Initializing")
  end

  defp initial_context() do
    IO.puts("Initializing context")
  end

  defp destroy() do
    IO.puts("Destroying")
  end

  defp shutdown() do
    IO.puts("Shutdown down....")
  end

end
