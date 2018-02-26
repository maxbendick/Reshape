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
altered in specific ways. You also might only care about one part of your state.
Sometimes the data can be large or deeply nested. You also might want to use a reusable
function to do your state transition. Lenses can help you meet these needs.
