# Reshape

Lenses can be incredibly helpful, but sometimes syntax and ceremony can get in the way. 
The goal of Reshape is to rethink how developers create lenses by taking advantage of
Elixir's pattern matching.

Reshape is purely experimental, and the ideal outcome is to contribute to an existing lens library.

```elixir
data = %{
  a: 5, 
  b: 6, 
  c: %{in: 10}
}

# Reshape.over updates `it`
res = Reshape.over %{c: %{in: it}}, data do
  it + 5
end

res == %{
  a: 5,
  b: 6,
  c: %{in: 15}
}
```

Check out the source and tests.

## Why lenses can be useful

Because state transitions in Elixir are pure, it's useful to create copies of data
altered in specific ways.

Lenses provide views on data. Lots of people think of them as functional setters and getters,
but I think of them more like a functional version of the adapter pattern. You can use lenses
to adapt a data structure to work with functions that don't know anything about your data structure.

I think they're especially ripe for improving reusability when working with GenServers and 
Redux (the JavaScript library). You can make general functions that take simple states
and return simple states, then create lenses to adapt your GenServer's own state to work with those functions.
