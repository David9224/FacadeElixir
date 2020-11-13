defmodule Main do
  alias Facade.FacadeImpl


  def main do
    {:ok, subject} = ScheduleServer.start_link(0)
    facade = %FacadeImpl{content: subject}

    IFacade.IFacade.start_server(facade)
    IO.puts("-------------------")
    IFacade.IFacade.stop_server(facade)
    IO.puts("-------------------")
    {:ok}
  end

end