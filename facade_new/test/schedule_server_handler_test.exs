defmodule ScheduleServerHandlerTest do
  use ExUnit.Case
  doctest ScheduleServerHandler

  test "Throws error " do
    {:ok, server} = ScheduleServer.start_link()
    handler = %ScheduleServerHandler{server: server}
    {:error, _} = ServerHandler.stop(handler)
  end

  test "Greets" do
    {:ok, server} = ScheduleServer.start_link()
    handler = %ScheduleServerHandler{server: server}
    assert ServerHandler.start(handler) == :ok
    assert ServerHandler.stop(handler) == :ok
  end
end