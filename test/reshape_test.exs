defmodule ReshapeTest do
  use ExUnit.Case
  doctest Reshape
  require Reshape

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

    res = Reshape.over l, %{a: 7}, fn x ->
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

    res = Reshape.over l, data, y_transform

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
end