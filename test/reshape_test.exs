defmodule ReshapeTest do
  use ExUnit.Case
  doctest Reshape
  require Reshape

  test "greets the world" do
    assert Reshape.hello() == :world
  end

  test "over assigns deep" do
    it = 1

    data = %{
      a: 5,
      b: 6,
      c: %{in: 49}
    }

    res =
      Reshape.over %{c: %{in: it}}, data do
        it + 5
      end

    assert it == 1

    assert res == %{
             a: 5,
             b: 6,
             c: %{in: 54}
           }
  end

  test "viewing" do
    it = 1

    data = %{
      a: 5,
      b: 6,
      c: %{in: 49}
    }

    res = Reshape.view(%{c: %{in: it}}, data)

    assert it == 1
    assert res == 49
  end

  # causes a compilation error:
  #
  # test "viewing without it" do
  #   data = %{
  #     a: 5, 
  #     b: 6, 
  #     c: %{in: 49}
  #   }

  #   res = Reshape.view %{c: %{in: it}}, data

  #   assert res == 49
  # end
end
