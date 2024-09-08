defmodule TaskmanagerTest do
  use ExUnit.Case
  doctest Taskmanager

  test "greets the world" do
    assert Taskmanager.hello() == :world
  end
end
