defmodule Facade do
  require IFacade.IFacade

  defmodule FacadeImpl do
    defstruct [:content]
  end

  defimpl IFacade.IFacade, for: FacadeImpl do

    def start_server(facade) do
      ScheduleServer.read_system_config_file(facade.content)
      ScheduleServer.initial(facade.content)
      ScheduleServer.initial_context(facade.content)
    end

    def stop_server(facade) do
      ScheduleServer.destroy(facade.content)
      ScheduleServer.shutdown(facade.content)
    end

    def read(facade) do
      ScheduleServer.read(facade.content)
    end
  end

  defimpl IFacade.IFacade, for: Any do
    def start_server(_), do: {:error}
    def stop_server(_), do: {:error}
    def read(_), do: {:error}
  end
end