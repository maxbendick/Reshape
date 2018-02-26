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

  test "over assigns with function" do
    it = 1

    data = %{
      a: 5,
      b: 6,
      c: %{in: 6}
    }

    res = Reshape.over(%{c: %{in: it}}, data, fn x -> x * 5 end)

    assert it == 1

    assert res == %{
             a: 5,
             b: 6,
             c: %{in: 30}
           }
  end

  test "over a list" do
    it = nil
    data = [1, 3, 5, 9]
    res = Reshape.over([it | rest], data, do: it - 2)
    assert res == [-1, 3, 5, 9]
  end

  test "over 2nd element of a list" do
    it = nil
    data = [1, 3, 5, 9]
    res = Reshape.over([_first | [it | rest]], data, do: it - 2)
    assert res == [1, 1, 5, 9]
  end

  test "over tuples" do
    it = nil
    data = {:a, :b, 3, :c}
    res = Reshape.over({:a, :b, it, :c}, data, do: it + 4)
    assert res == {:a, :b, 7, :c}
  end

  test "over with variables" do
    it = nil
    x = 3
    res = Reshape.over {:a, :b, it, :c}, {:a, :b, x, :c} do
      it + 4
    end
    assert res == {:a, :b, 7, :c}
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