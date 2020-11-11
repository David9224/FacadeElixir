defmodule Singleton do
  use GenServer

  @name :bit_singleton
  #@name {:global, :bit_singleton}

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: @name)
  end

  def init(value) do
    {:ok, value}
  end

  def read() do
    GenServer.call(@name, :read)
  end

  def write(new_value) do
    GenServer.call(@name, {:write, new_value})
  end

  def handle_call(:read, __from, value) do
    {:reply, value, value}
  end

  def handle_call({:write, new_value}, __from, _) do
    {:reply, :ok, new_value}
  end
end
