defmodule MyAgentTest do
  use ExUnit.Case
  doctest MyAgent

  test "Raises an error on start" do
    reason = "some reason"
    {:error, e} = MyAgent.start_link(fn -> raise reason end)
    assert e.__struct__ == RuntimeError
    assert e.message == reason
  end

  test "Creates an MyAgent and gets 30" do
    initial = 30
    {:ok, pid} = MyAgent.start_link(fn -> initial end)
    ^initial = MyAgent.get(pid, fn val -> val end)
    MyAgent.stop(pid)

    {:ok, pid} = MyAgent.start_link(fn -> {initial, true} end)
    ^initial = MyAgent.get(pid, fn {val, true} -> val end)
    MyAgent.stop(pid)
  end

  #@tag :wip
  test "Updates an MyAgent" do
    initial = 10
    {:ok, pid} = MyAgent.start_link(fn -> {initial, true} end)
    assert :ok == MyAgent.update(pid, fn {val, bool} -> {val + 1, not bool} end)
    expected = initial + 1
    {^expected, false} = MyAgent.get(pid, fn state -> state end)
    MyAgent.stop(pid)
  end

#  @tag :wip
  test "Stops the MyAgent" do
    initial = 10
    {:ok, pid} = MyAgent.start_link(fn -> {initial, true} end)
    MyAgent.stop(pid)

    try do
      MyAgent.get(pid, fn state -> state end)
      raise "The MyAgent is stopped and must not get a value from state"
    catch
      :exit, _ -> nil
    end

    try do
      MyAgent.update(pid, fn state -> state end)
      raise "The MyAgent is stopped and must not updated the state"
    catch
      :exit, _ -> nil
    end
  end
end