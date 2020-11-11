defmodule FacadeTest do
  use ExUnit.Case
  doctest Facade

  alias Facade.FacadeImpl

  test "start server" do
    {:ok, subject} = ScheduleServer.start_link()
    facade = %FacadeImpl{content: subject}

    IFacade.IFacade.start_server(facade)

    assert IFacade.IFacade.read(facade) == "initial_context"
  end

  test "stop server" do
    {:ok, subject} = ScheduleServer.start_link()
    facade = %FacadeImpl{content: subject}

    IFacade.IFacade.stop_server(facade)

    assert IFacade.IFacade.read(facade) == "shutdown"
  end

  test "start server any" do
    {:ok, subject} = ScheduleServer.start_link()

    assert IFacade.IFacade.start_server("facade") == {:error}
  end

  test "stop server any" do
    {:ok, subject} = ScheduleServer.start_link()

    assert IFacade.IFacade.stop_server("facade") == {:error}
  end

  test "read server any" do
    {:ok, subject} = ScheduleServer.start_link()

    assert IFacade.IFacade.read("facade") == {:error}
  end

end
