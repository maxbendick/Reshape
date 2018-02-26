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
end
