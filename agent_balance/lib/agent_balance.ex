defmodule AgentBalance do
  def start_link(initial_amount \\ 0) do
    if initial_amount < 0 do
      {:error, "Initial amount can't be negative"}
    else
      Agent.start_link(fn -> initial_amount end)
    end
  end

  def read(balance) do
    Agent.get(balance, fn state -> state end)
  end

  def deposit(balance, amount) when amount > 0 do
    Agent.update(balance, fn state -> state + amount end)
    read(balance)
  end

  def withdraw(balance, amount) when amount > 0 do
    Agent.update(balance, fn state -> state - amount end)
    read(balance)
  end

  def close(balance) do
    amount = read(balance)
    Agent.stop(balance)
    amount
  end

end
