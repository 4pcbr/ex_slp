defmodule ExSlpTest do
  use ExUnit.Case
  doctest ExSlp

  test "opens a new handle if no lang provided and async=false" do
    assert { :ok, handle } = ExSlp.open(nil, false)
  end

  test "returns SLP_NOT_IMPLEMENTED if no lang procided and async=true" do
    assert { :error, :SLP_NOT_IMPLEMENTED } = ExSlp.open(nil, true)
  end

  test "returns a new handle if :en lang provided and async=false" do
    assert { :ok, handle } = ExSlp.open(:en, false)
  end

  test "closes an existing handle" do
    { :ok, handle } = ExSlp.open(nil, false)
    :ok = ExSlp.close(handle)
  end

end
