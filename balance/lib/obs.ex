defmodule Obs do
  use GenServer

  defstruct [:value, observers: []]

  @spec create(integer()) :: pid()
  def create(initial_state \\ 0) do
    state = %Obs{value: initial_state}
    GenServer.start_link(__MODULE__, state)
  end

  def init(state), do: {:ok, state}

  def add_observer(observers, observer_pid) do
    [observer_pid | observers]
  end

  def remove_observer(observers, observer_pid) do
    observers -- [observer_pid]
  end

  defp notify(state) do
    state.observers |> Enum.each(&(send(&1, state.value)))
  end

  def attach(subject), do: GenServer.cast(subject, {:attach, self()})
  def detach(subject), do: GenServer.cast(subject, {:detach, self()})

  def read(subject), do: GenServer.call(subject, :read)

  def handle_call(:read, __reader_id, state) do
    {:reply, state.value, state}
  end

  def handle_cast({:attach, observer_pid}, state) do
    new_observers = state.observers |> add_observer(observer_pid)
    {:noreply, Map.put(state, :observers, new_observers)}
  end

  def handle_cast({:detach, observer_pid}, state) do
    new_observers = state.observers |> remove_observer(observer_pid)
    {:noreply, Map.put(state, :observers, new_observers)}
  end

  ## Extending
  def handle_cast(:increment, state) do
    state = Map.put(state, :value, state.value + 1)
    notify(state)
    {:noreply, state}
  end

  def handle_cast(:decrement, state) do
    state = Map.put(state, :value, state.value - 1)
    notify(state)
    {:noreply, state}
  end

  def increment(subject), do: GenServer.cast(subject, :increment)
  def decrement(subject), do: GenServer.cast(subject, :decrement)

  def await() do
    receive do
      count -> count
    after
      2000 -> "There was no answer"
    end
  end
end
