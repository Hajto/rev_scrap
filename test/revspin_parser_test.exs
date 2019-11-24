defmodule RevScam.RevspinParserTest do
  use ExUnit.Case

  test "Successfully parses a rubber" do
    assert File.read!("fixture/data/rubber_page.html")
           |> RevScam.RevspinParser.parse_rubber_details() ==
             %{
               consistency: 9.0,
               control: 9.2,
               durability: 7.9,
               gears: 8.2,
               sponge_hardness: 5.6,
               overall: 9.3,
               speed: 9.1,
               spin: 9.4,
               tackiness: 6.0,
               throw_angle: 6.2,
               weight: 5.1,
               ratings: 35,
               price: 30.0,
               name: "Galaxy Moon Pro"
             }
  end

  test "Successfully parses a blade" do
    assert File.read!("fixture/data/blade_page.html")
           |> RevScam.RevspinParser.parse_blade_details() ==
             %{
               consistency: 10.0,
               control: 9.1,
               hardness: 4.1,
               overall: 9.2,
               speed: 7.0,
               stiffness: 3.6,
               ratings: 7,
               price: 45.0,
               name: "Donic Appelgren Allplay Senso V2"
             }
  end

  test "Extracts links from blades page" do
    assert File.read!("fixture/data/blades.html")
           |> RevScam.RevspinParser.parse_links()
           |> Enum.into(%{}) ==
             File.read!("fixture/data/links.json") |> Jason.decode!()
  end
end
