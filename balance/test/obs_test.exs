defmodule ObsTest do
  use ExUnit.Case
  doctest Obs

  test "structure Obs with default observables" do
    obs = %Obs{value: 12}
    assert obs.observers == []
  end

  test "Create server" do
    {:ok, subject} = Obs.create()
    assert Obs.read(subject) == 0
  end

  test "Create server with initial value" do
    {:ok, subject} = Obs.create(10)
    assert Obs.read(subject) == 10
  end

  test "increments value without attach" do
    {:ok, subject} = Obs.create()
    Obs.increment(subject)
    assert Obs.read(subject) == 1
  end

  test "decrements value without attach" do
    {:ok, subject} = Obs.create(1)
    Obs.decrement(subject)
    assert Obs.read(subject) == 0
  end

  test "increments value with attach" do
    {:ok, subject} = Obs.create()
    Obs.attach(subject)
    Obs.increment(subject)
    assert Obs.await() == 1
  end

  test "decrements value with attach" do
    {:ok, subject} = Obs.create(1)
    Obs.attach(subject)
    Obs.decrement(subject)
    assert Obs.await() == 0
  end

  test "attach observer" do
    {:ok, subject} = Obs.create()
    Obs.attach(subject)
    assert Obs.read(subject) == 0
  end

  test "detach observer" do
    {:ok, subject} = Obs.create()
    Obs.increment(subject)
    assert_receive {:trace, 1000, ""}
#    {:error, _} = Obs.await()
#    Obs.attach(subject)
#    Obs.increment(subject)
  end



end
