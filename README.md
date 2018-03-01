# Reshape

Lenses can be incredibly helpful, but sometimes syntax and ceremony can get in the way. 
The goal of Reshape is to rethink how developers create lenses by taking advantage of
Elixir's pattern matching.

Reshape is purely experimental, and the ideal outcome is to contribute to an existing lens library.

```elixir

lens = Reshape.lens %{a: %{b: it}}

data = %{a: %{b: 7}, c: 2}

7 == Reshape.get lens, data

%{a: %{b: 8}, c: 2} == Reshape.set lens, data, 8

res = Reshape.fover lens, data, fn x ->
  x * 2
end

res == %{a: %{b: 14}, c: 2}
```

Check out the source and tests.

## Reverse pattern matching

Pattern matching is awesome for getting values out of data structures.
A single pattern can work on an infinite amount of structures - as long as the matched structures have the required pieces.

Interestingly, there's enough information in a pattern to create a setter, too. As long as we know the path to a piece
of a structure, we can get it and set it.

Now that we can get AND set values using patterns, it's sensical to make lenses with the getters and setters.
A lens not only provides convenient access to getters and setters, it also allows for sweet combinators like
`compose` and `over`.

## Why lenses can be useful

Lenses provide views on data. Lots of people think of them as functional setters and getters,
but I think of them more like a functional version of the adapter pattern. You can use lenses
to adapt a data structure to work with functions that don't know anything about your data structure.

I think they're especially ripe for improving reusability when working with GenServers, 
Redux (the JavaScript library), and functions from state to state generally. You can make general 
functions that take simple states and return simple states, then create lenses to adapt your 
GenServer's own state to work with those functions.
