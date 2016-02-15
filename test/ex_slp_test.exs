defmodule ExSlpTest do
  use ExUnit.Case
  doctest ExSlp

  test "opens a new handle if no lang provided and async=false" do
    assert { :ok, handle } = ExSlp.open(nil, false)
  end

end
