defmodule AgentBalanceTest do
  use ExUnit.Case
  doctest AgentBalance

  test "Initial amount must'b be negativo" do
    {:error, reason} = AgentBalance.start_link(-100)
    assert reason == "Initial amount can't be negative"
  end

  test "Default initial amount must be zero" do
    {:ok, balance} = AgentBalance.start_link()
    assert AgentBalance.read(balance) == 0
  end

  test "Creates a balance with a initial amount" do
    {:ok, balance} = AgentBalance.start_link(1000)
    assert AgentBalance.read(balance) == 1000
  end

  test "Raise error when depositing a negative amount" do
    {:ok, balance} = AgentBalance.start_link(1000)
    try do
      AgentBalance.deposit(balance, -100)
    rescue
      FunctionClauseError -> nil
    end
  end

  test "Increments amount in 100" do
    {:ok, balance} = AgentBalance.start_link(1000)
    amount = AgentBalance.deposit(balance, 100)
    assert amount == 1100
    assert AgentBalance.read(balance) == amount
  end

  test "Raise error when withdrawing a negative amount" do
    {:ok, balance} = AgentBalance.start_link(1000)
    try do
      AgentBalance.withdraw(balance, -100)
    rescue
      FunctionClauseError -> nil
    end
  end

  test "Decrements amount in 30" do
    {:ok, balance} = AgentBalance.start_link(1100)
    amount = AgentBalance.withdraw(balance, 30)
    assert amount == 1070
    assert AgentBalance.read(balance) == amount
  end

  test "Closes the balance" do
    amount = 1000
    {:ok, balance} = AgentBalance.start_link(amount)
    ^amount = AgentBalance.close(balance)
  end
end
