defmodule RevScamTest do
  use ExUnit.Case

  test "WIP" do
    RevScam.Repo.start_link()
    RevScam.process_data()
  end
end
