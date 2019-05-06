defmodule Elixir2faTest do
  use ExUnit.Case
  doctest Elixir2fa

  test "greets the world" do
    assert Elixir2fa.random_secret() == :world
  end
end
