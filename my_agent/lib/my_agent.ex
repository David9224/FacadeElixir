defmodule MyAgent do
  use GenServer

  def start_link(onCreate) when not is_nil(onCreate) do
    try do
      GenServer.start_link(__MODULE__, onCreate.())
    rescue
     e -> {:error, e}
    end

  end

  def init(state), do: {:ok, state}

  def get(agent, onGet) do
    GenServer.call(agent, :read)
    |> onGet.()
  end

  def update(agent, on_update) do
    GenServer.call(agent, {:update, on_update})
  end

  def stop(agent) do
    GenServer.stop(agent)
  end

  def handle_call(:read, _from_id, state) do
    {:reply, state, state}
  end

  def handle_call({:update, on_update}, _from_id, state) do
    {
      :reply,
      :ok,
      state
      |> on_update.()
    }
  end

  #  def terminate(reason, state) do
  #    IO.inspect("I'm dead: #{reason}")
  #    IO.inspect(state)
  #    :normal
  #  end
end
