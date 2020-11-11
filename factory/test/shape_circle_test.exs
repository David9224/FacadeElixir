defmodule Shape.CircleTest do
  use ExUnit.Case
  doctest Shape.Circle

  alias Shape.Circle

  test "structure Circle with default values" do
    circle = %Circle{radius: 2}
    assert circle.radius == 2
  end

  test "Creates circle with the creator method" do
    try do
      Circle.create(nil)
      raise "Thee radius must be no-nil"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Circle.create(-2)
      raise "Thee radius must be positive"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Circle.create(0)
      raise "Thee radius must be greater than zero"
    rescue
      FunctionClauseError -> nil
    end

    circle = Circle.create(1.5)
    assert circle.radius == 1.5
  end
end