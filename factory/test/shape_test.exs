defmodule FactoryTest do
  use ExUnit.Case
  doctest Shape

  # @tag :wip
  test "Creates a circle from radius" do
    circle = Shape.create(:circle, %{radius: 5})
    assert Shape.perimeter(circle) == 10 * :math.pi()
    assert Shape.area(circle) == 25 * :math.pi()
  end

  test "Creates a rectangle from width an height" do
    rect = Shape.create(:rectangle, %{width: 3, height: 4})
    assert Shape.perimeter(rect) == 14
    assert Shape.area(rect) == 12
  end

  test "Creates a rectangle from size" do
    rect = Shape.create(:square, %{size: 5})
    assert Shape.perimeter(rect) == 20
    assert Shape.area(rect) == 25
  end
end
