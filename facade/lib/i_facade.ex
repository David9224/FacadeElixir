defmodule IFacade do

  defprotocol IFacade do
    @fallback_to_any true
    def start_server(content)
    def stop_server(content)
  end

end
