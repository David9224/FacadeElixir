defmodule Facade do
  require IFacade.IFacade

  defmodule FacadeImpl do
    defstruct [:content]
  end

  defimpl IFacade.IFacade, for: FacadeImpl do

    def start_server(content) do
      ScheduleServer.read_system_config_file(content.content)
      ScheduleServer.initial(content.content)
      ScheduleServer.initial_context(content.content)
    end

    def stop_server(content) do
      ScheduleServer.destroy(content.content)
      ScheduleServer.shutdown(content.content)
    end

    def read(content) do
      ScheduleServer.read(content.content)
    end
  end

  defimpl IFacade.IFacade, for: Any do
    def start_server(_), do: {:error}
    def stop_server(_), do: {:error}
    def read(_), do: {:error}
  end
end