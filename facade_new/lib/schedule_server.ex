defmodule ScheduleServer do
  use Agent

  defstruct is_read: false, is_running: false, has_context: false

  def start_link do
    Agent.start_link(fn -> %ScheduleServer{} end)
  end

  def read_system_config_file(server) do
    IO.puts("Reading system config files...")
    state = Agent.get(server, fn state -> state end)

    cond do
      state.is_running ->
        IO.puts("The server is already running")
        {:error, :already_running}
      state.is_read ->
        IO.puts("The config files have been read")
        {:error, :already_read}
      true ->
        try do
          Process.sleep(50)
          IO.puts("Config files ok!")
          Agent.update(server, fn state -> %{state | :is_read => true} end)
        rescue
          e  -> {:error, e.message}
        end
    end
  end

  def start(server) do
    state = Agent.get(server, fn state -> state end)

    cond do
      state.is_running ->
        IO.puts("The server is already running")
        {:error, :already_running}
      not state.is_read ->
        IO.puts("The condig files are not loaded")
        {:error, :no_config_files}
      true ->
        IO.puts("Initialiazing")
        Agent.update(server, fn state -> %{state | :is_running => true} end)
    end
  end

  def initialize_context(server) do
    state = Agent.get(server, fn state -> state end)

    if not state.is_running do
      IO.puts("The server is not running")
      {:error, :server_not_running}
    else
      IO.puts("Initializing context")
      Agent.update(server, fn state -> %{state | :has_context => true} end)
    end
  end

  def destroy(server) do
    state = Agent.get(server, fn state -> state end)

    if state.has_context do
      IO.puts("Destroying")

      Agent.update(server, fn state ->
        state = %{state | :has_context => false}
        %{state | :is_running => false}
      end)
    else
      IO.puts("Already Destroy...")
      {:error, :already_destroyed}
    end
  end

  def shutdown(server) do
    state = Agent.get(server, fn state -> state end)

    if state.is_running do
      IO.puts("The server must be destroy first")
      {:error, :not_destroyed}
    else
      IO.puts("Shutdown...")
      Agent.stop(server)
    end

  end

  def read_system_config_file!(server), do: checker!(read_system_config_file(server))
  def start!(server), do: checker!(start(server))
  def initialize_context!(server), do: checker!(initialize_context(server))
#  def destroy!(server), do: checker!(destroy(server))
#  def shutdown!(server), do: checker!(shutdown(server))

  def checker!(answer) do
    case answer do
      :ok -> :ok
     {:error, atom_reason} -> raise atom_reason
    end
  end
end
