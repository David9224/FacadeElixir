defmodule FacadeImplTest do
  use ExUnit.Case
  doctest Facade

  alias Facade.FacadeImpl

  test "structure FacadeImpl with default values" do
    facade_impl = %FacadeImpl{}
    assert facade_impl.content == nil
  end

  test "structure FacadeImpl with values" do
    facade_impl = %FacadeImpl{content: 1}
    assert facade_impl.content == 1
  end

end
