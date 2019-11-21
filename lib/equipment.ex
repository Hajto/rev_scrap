defmodule RevScam.Equipment do
  alias RevScam.Repo
  alias RevScam.Schema.{Blade, Brand, Rubber}

  def upsert_brand(name) do
    Repo.get_by(Brand, name: name) || Brand.changeset(%Brand{}, %{name: name}) |> Repo.insert!()
  end

  def change_entries_to_blades(%Brand{} = brand, entries) do
    entries
    |> Enum.map(fn entry ->
      {speed, control, stiffness} = entry.ratings

      blade_params = %{
        name: entry.model_name,
        speed: speed,
        control: control,
        stiffness: stiffness,
        overall: entry.overall,
        brand_id: brand.id,
        price: entry.price,
        ratings: entry.number_of_ratings
      }

      Blade.changeset(%Blade{}, blade_params)
    end)
    |> Enum.filter(& &1.valid?)
  end

  def change_entries_to_rubber(%Brand{} = brand, entries) do
    entries
    |> Enum.map(fn entry ->
      {speed, spin, tackiness} = entry.ratings

      rubber_params = %{
        name: entry.model_name,
        speed: speed,
        tackiness: tackiness,
        spin: spin,
        overall: entry.overall,
        brand_id: brand.id,
        price: entry.price,
        ratings: entry.number_of_ratings
      }

      Rubber.changeset(%Rubber{}, rubber_params)
    end)
    |> Enum.filter(& &1.valid?)
  end
end
