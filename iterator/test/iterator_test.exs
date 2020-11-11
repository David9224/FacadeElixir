defmodule IteratorTest do
  use ExUnit.Case
  doctest Iterator

  test "Creating iterator" do
    list = [1, 3, 5, 9, 7]
    {:ok, iter} = Iterator.new(list)
    each(iter, list, 0)
  end

  def each(pid, list, index) do
    is_there_a_next = Iterator.next?(pid)
    assert is_boolean(is_there_a_next)

    if is_there_a_next do
      assert Iterator.next(pid) == Enum.at(list, index)
      each(pid, list, index + 1)
    end

    assert index == length(list) - 1
  end
end
