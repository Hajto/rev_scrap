defmodule RevScam.RevspinApiTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias RevScam.RevspinApi

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  test "httpotion" do
    use_cassette "link_retrieval" do
      assert RevspinApi.find_links("blade") |> Enum.into(%{}) ==
               File.read!("fixture/data/links.json") |> Jason.decode!()
    end
  end
end
