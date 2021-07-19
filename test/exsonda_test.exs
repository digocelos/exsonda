defmodule ExsondaTest do
  use ExUnit.Case
  doctest Exsonda

  test "greets the world" do
    assert Exsonda.hello() == :world
  end
end
