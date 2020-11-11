defmodule Shape.RectangleTest do
  use ExUnit.Case
  doctest Shape.Rectangle

  alias Shape.Rectangle

  test "is_positive must work" do
    assert !Rectangle.is_positive(nil)
    assert !Rectangle.is_positive(-2)
    assert !Rectangle.is_positive(0)
    assert Rectangle.is_positive(3.0)
  end

  test "structure Rectangle with default values" do
    rect = %Rectangle{width: 2, height: 2}
    assert rect.width == 2
    assert rect.height == 2
  end

  test "Creates rectangle with the creator method" do
    try do
      Rectangle.create(nil, 2)
      raise "The width must be no-nil"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Rectangle.create(2, nil)
      raise "The height must be no-nil"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Rectangle.create(-2, 2)
      raise "The width must be positive"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Rectangle.create(2, -2)
      raise "The height must be positive"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Rectangle.create(0, 1)
      raise "The width must be greater than zero"
    rescue
      FunctionClauseError -> nil
    end

    try do
      Rectangle.create(1, 0)
      raise "The height must be greater than zero"
    rescue
      FunctionClauseError -> nil
    end

    rect = Rectangle.create(2, 2)
    assert rect.width == 2
    assert rect.height == 2
  end
end