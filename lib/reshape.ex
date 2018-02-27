defmodule Reshape do
  @moduledoc """
  Documentation for Reshape.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Reshape.hello
      :world

  """
  def hello do
    :world
  end

  defmacro over(mat, data, do: body) do
    quote do
      # Manual hygiene because matching breaks built-in hygiene :(
      old_it = var!(it)

      unquoted_data = unquote(data)

      # This will give us `it` because the pattern has `it`.
      unquote(mat) = unquoted_data

      # Apply the transform
      var!(it) = unquote(body)

      matched_new_data = unquote(mat)

      # Merge the pattern (which contains `it`) and the original data 
      res =
        if is_map(unquoted_data) do
          Map.merge(unquoted_data, matched_new_data)
        else
          matched_new_data
        end

      # Enforce hygiene
      var!(it) = old_it
      res
    end
  end

  defmacro over(mat, data, f) do
    quote do
      # Manual hygiene because matching breaks built-in hygiene :(
      old_it = var!(it)

      unquoted_data = unquote(data)

      # This will give us `it` because the pattern has `it`.
      unquote(mat) = unquoted_data

      # Apply the transform
      var!(it) = unquote(f).(var!(it))

      matched_new_data = unquote(mat)

      # Merge the pattern (which contains `it`) and the original data 
      res =
        if is_map(unquoted_data) do
          Map.merge(unquoted_data, matched_new_data)
        else
          matched_new_data
        end

      # Enforce hygiene
      var!(it) = old_it
      res
    end
  end

  defmacro view(mat, data) do
    quote do
      # Manual hygiene because matching like we do breaks built-in hygiene :(
      old_it = var!(it)

      # This will give us `it` because the pattern has `it`
      unquote(mat) = unquote(data)

      res = var!(it)

      # Enforce hygiene
      var!(it) = old_it
      res
    end
  end

  defmacro getter(pattern) do
    quote do
      fn data ->
        # destructure data with the pattern, assigning to `it`
        unquote(pattern) = data
        var!(it)
      end
    end
  end

  defmacro setter(pattern) do
    quote do
      fn data, new_it ->
        # we're in a fn, so hygiene is free
        var!(it) = new_it

        # the new data is the pattern, where `it` is a variable referencing new_it
        new_data = unquote(pattern)

        if is_map(new_data) do
          Map.merge(data, new_data)
        else
          new_data
        end
      end
    end
  end

  defstruct [:get, :set]

  defmacro lens(pattern) do
    quote do
      %Reshape{
        get: Reshape.getter(unquote(pattern)),
        set: Reshape.setter(unquote(pattern)),
      }
    end
  end

  def fover(%{get: get, set: set}, data, f) do
    a = get.(data)
    b = f.(a)
    c = set.(data, b)
    c
  end

  def get(%{get: get}, data) do
    get.(data)
  end

  def set(%{set: set}, data, x) do
    set.(data, x)
  end

  def compose(%{set: outter_set, get: outter_get}, %{set: inner_set, get: inner_get}) do
    %Reshape{
      get: fn data ->
        data
        |> outter_get.()
        |> inner_get.()
      end,

      set: fn data, new_it ->
        level1 = outter_get.(data)
        new_level1 = inner_set.(level1, new_it)
        outter_set.(data, new_level1)
      end
    }
  end
end
