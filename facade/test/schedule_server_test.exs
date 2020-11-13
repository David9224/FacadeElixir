defmodule ScheduleServerTest do
  use ExUnit.Case
  doctest ScheduleServer

  test "Multiple declarations" do
    {:ok, single_pid} = ScheduleServer.start_link(0)

    {:error, {:already_started, ^single_pid}} = ScheduleServer.start_link(1)
    assert ScheduleServer.read(single_pid) == 0
  end

  test "create Server" do
    {:ok, subject} = ScheduleServer.start_link()
    assert ScheduleServer.read(subject) == 0
  end

  test "create Server with values" do
    {:ok, subject} = ScheduleServer.start_link(1)
    assert ScheduleServer.read(subject) == 1
  end

  test "read system config server" do
    {:ok, subject} = ScheduleServer.start_link()
    ScheduleServer.read_system_config_file(subject)
    assert ScheduleServer.read(subject) == :read_system_config_file
  end

  test "initial server" do
    {:ok, subject} = ScheduleServer.start_link()
    ScheduleServer.initial(subject)
    assert ScheduleServer.read(subject) == :initial
  end

  test "initial context server" do
    {:ok, subject} = ScheduleServer.start_link()
    ScheduleServer.initial_context(subject)
    assert ScheduleServer.read(subject) == :initial_context
  end

  test "destroy server" do
    {:ok, subject} = ScheduleServer.start_link()
    ScheduleServer.destroy(subject)
    assert ScheduleServer.read(subject) == :destroy
  end

  test "shutdown server" do
    {:ok, subject} = ScheduleServer.start_link()
    ScheduleServer.shutdown(subject)
    assert ScheduleServer.read(subject) == :shutdown
  end

end
