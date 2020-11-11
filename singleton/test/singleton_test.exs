defmodule SingletonTest do
  use ExUnit.Case
  doctest Singleton

  test "create singleton" do
    Singleton.start_link("Hola")
    assert Singleton.read() == "Hola"
    assert Singleton.write("Hallo") == :ok
    assert Singleton.read() == "Hallo"
  end

  test "Multiple declarations" do
    #{:ok, #PID}
    {:ok, single_pid} = Singleton.start_link("Hola")

    #{:error, {:already_started, #PID}}
    {:error, {:already_started, ^single_pid}} = Singleton.start_link("Hallo")

    assert Singleton.read() == "Hola"
  end
end
