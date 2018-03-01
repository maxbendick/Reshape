defmodule ReshapeTest do
  use ExUnit.Case
  doctest Reshape
  require Reshape

  test "greets the world" do
    assert Reshape.hello() == :world
  end

  test "get" do
    %Reshape{get: get, set: set} = l = Reshape.lens %{a: it}

    assert 7 == Reshape.get l, %{a: 7}
    assert 7 == get.(%{a: 7})
  end

  test "set" do
    %Reshape{get: get, set: set} = l = Reshape.lens %{a: it}

    assert %{a: 1} == Reshape.set l, %{a: 7}, 1
    assert %{a: 1} == set.(%{a: 7}, 1)
  end

  test "functional over" do
    l = Reshape.lens %{a: it}

    res = Reshape.fover l, %{a: 7}, fn x ->
      x * 2
    end

    assert %{a: 14} == res
  end

  # Failing
  test "deeper over" do
    l = Reshape.lens %{
      loc: %{
        y: it
      }
    }

    data = %{
      a: 1,
      b: 2,
      loc: %{
        x: 1,
        y: 109,
        z: %{a: 1}
      },
      other_loc: %{
        x: 3,
        y: 4,
        z: %{a: 2}
      },
    }

    y_transform = fn y ->
      y + 2
    end

    res = Reshape.fover l, data, y_transform

    expected = %{
      a: 1,
      b: 2,
      loc: %{
        x: 1,
        y: 111,
        z: %{a: 1}
      },
      other_loc: %{
        x: 3,
        y: 4,
        z: %{a: 2}
      },
    }

    assert expected == res
  end

  test "compose" do
    l1 = Reshape.lens %{a: it}
    l2 = Reshape.lens %{b: it}
    l = Reshape.compose l1, l2

    data = %{a: %{b: 7}}

    assert 7 == Reshape.get l, data
    assert %{a: %{b: 8}} == Reshape.set l, data, 8
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

  # This feature will be useful... later
  # test "over with many bindings" do
  #   it = nil
  #   data = %{a: 1, b: 2, c: 3, d: 5}

  #   res = Reshape.over %{c: x, d: y}, data do
  #     new_y = 0 - y

  #     %{x: 0 - x, y: new_y}
  #   end

  #   assert res ==  %{a: 1, b: 2, c: -3, d: -5}
  # end

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