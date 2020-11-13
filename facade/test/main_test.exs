defmodule MainTest do
  use ExUnit.Case
  doctest Main

  test "main method" do
    assert {:ok} == Main.main()
  end
end