defmodule RevScam.DetailsImporter do
  alias RevScam.Repo
  alias RevScam.RevspinParser
  alias RevScam.Schema.{Blade, Brand, Rubber}

  def perform(brand, type, link) do
    brand = upsert_brand(brand)

    link
    |> RevScam.RevspinApi.get_details()
    |> parse_result(type)
    |> Map.put(:brand_id, brand.id)
    |> insert_data(type)
  end

  defp upsert_brand(name) do
    {:ok, brand} =
      Repo.transaction(fn ->
        Repo.get_by(Brand, name: name) ||
          Brand.changeset(%Brand{}, %{name: name}) |> Repo.insert!()
      end)

    brand
  end

  def parse_result(data, "blade"), do: RevspinParser.parse_blade_details(data)
  def parse_result(data, "rubber"), do: RevspinParser.parse_rubber_details(data)

  defp insert_data(data, "blade") do
    %Blade{}
    |> Blade.changeset(data)
    |> Repo.insert()
  end

  defp insert_data(data, "rubber") do
    %Rubber{}
    |> Rubber.changeset(data)
    |> Repo.insert()
  end
end
