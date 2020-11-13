defmodule ScheduleServerTest do
  use ExUnit.Case
  doctest ScheduleServer

  def check_default_values(server) do
    assert server.is_read == false
    assert server.is_running == false
    assert server.has_context == false
  end

  test "Creates a ScheduleServer" do
    server = %ScheduleServer{}
    check_default_values(server)
  end

  test "starts link" do
    {:ok, server_pid} = ScheduleServer.start_link()
    server = Agent.get(server_pid, fn state -> state end)
    check_default_values(server)
  end

  test "Read config file one and many time without starting" do
    {:ok, server} = ScheduleServer.start_link()

    :ok = ScheduleServer.read_system_config_file(server)
    {:error, :already_read} = ScheduleServer.read_system_config_file(server)
  end

  test "Read config file after starting" do
    {:ok, server} = ScheduleServer.start_link()

    :ok = ScheduleServer.read_system_config_file(server)
    :ok = ScheduleServer.start(server)
    {:error, :already_running} = ScheduleServer.read_system_config_file(server)
  end

  test "Throws error when server starts wiithout reading config files" do
    {:ok, server} = ScheduleServer.start_link()
    {:error, :no_config_files} = ScheduleServer.start(server)
  end

  test "Starts one and many times" do
    {:ok, server} = ScheduleServer.start_link()

    :ok = ScheduleServer.read_system_config_file(server)
    :ok = ScheduleServer.start(server)
    {:error, :already_running} = ScheduleServer.start(server)
  end

  test "Throws error when initialize context without start server" do
    {:ok, server} = ScheduleServer.start_link()
    {:error, :server_not_running} = ScheduleServer.initialize_context(server)

    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file(server)
    {:error, :server_not_running} = ScheduleServer.initialize_context(server)
  end

  test "Initialize context with success" do
    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file(server)
    :ok = ScheduleServer.start(server)
    :ok = ScheduleServer.initialize_context(server)
  end

  test "Throws error when destroy server without context" do
    {:ok, server} = ScheduleServer.start_link()
    {:error, :already_destroyed} = ScheduleServer.destroy(server)
  end

  test "Destroies a server with context" do
    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file(server)
    :ok = ScheduleServer.start(server)
    :ok = ScheduleServer.initialize_context(server)
    :ok = ScheduleServer.destroy(server)
  end

  test "Throws error when shutdowns server when server is running" do
    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file(server)
    :ok = ScheduleServer.start(server)
    {:error, :not_destroyed} = ScheduleServer.shutdown(server)
  end

  test "Shutdown server" do
    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file(server)
    assert :ok = ScheduleServer.shutdown(server)

    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file(server)
    :ok = ScheduleServer.start(server)
    :ok = ScheduleServer.initialize_context(server)
    :ok = ScheduleServer.destroy(server)
    assert :ok = ScheduleServer.shutdown(server)
  end

  test "Handles error for read_system_config_file!" do
    {:ok, server} = ScheduleServer.start_link()
    assert :ok = ScheduleServer.read_system_config_file!(server)
  end

  test "Handles error for start!" do
    {:ok, server} = ScheduleServer.start_link()

    try do
      ScheduleServer.start!(server)
      raise "ScheduleServer.start! must raise an error"
    rescue
      e -> assert is_atom(e.message)
    end

    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file!(server)
    assert :ok = ScheduleServer.start!(server)
  end

  test "Handles error for initialize_context!" do
    {:ok, server} = ScheduleServer.start_link()

    try do
      ScheduleServer.initialize_context!(server)
      raise "ScheduleServer.initialize_context! must raise an error"
    rescue
      e -> assert is_atom(e.message)
    end

    {:ok, server} = ScheduleServer.start_link()
    :ok = ScheduleServer.read_system_config_file!(server)
    :ok = ScheduleServer.start!(server)
    assert :ok = ScheduleServer.initialize_context!(server)
  end

  test "Hanldes error with checker!" do
    assert ScheduleServer.checker!(:ok) == :ok

    try do
      ScheduleServer.checker!({:error, :some_error})
    rescue
      e -> assert is_atom(e.message)
    end
  end
end