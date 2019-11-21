defmodule RevScam do
  alias RevScam.Equipment
  @revspin_url "https://revspin.net/"

  def process_data() do
    process_blades()
    process_rubbers()
  end

  def process_blades() do
    process_entity("blade/", &Equipment.change_entries_to_blades/2)
  end

  def process_rubbers() do
    process_entity("rubber/", &Equipment.change_entries_to_rubber/2)
  end

  defp process_entity(path, mapper) do
    (@revspin_url <> path)
    |> process_endpoint()
    |> Enum.map(fn {brand, entries} ->
      Equipment.upsert_brand(brand)
      |> mapper.(entries)
      |> Enum.map(&RevScam.Repo.insert/1)
    end)
  end

  defp process_endpoint(endpoint) do
    response = HTTPoison.get!(endpoint)

    Floki.find(response.body, ".max-xxs")
    |> Enum.map(fn {"div", attributes, _children} = tag ->
      case :lists.keyfind("id", 1, attributes) do
        {"id", id} ->
          if String.starts_with?(id, "brand") do
            {id, tag}
          else
            false
          end

        _ ->
          false
      end
    end)
    |> Enum.filter(&match?({_, _}, &1))
    |> Enum.map(fn {brand_name, brand} ->
      brand_name = String.replace_prefix(brand_name, "brand-", "")

      entries =
        Floki.find(brand, "tr")
        |> Enum.drop(1)
        |> Enum.map(&parse_entry/1)

      {brand_name, entries}
    end)
  end

  defp parse_entry(blade_html) do
    {"tr", _,
     [
       {"td", _,
        [
          {"a", [{"href", link_for_details}, {"target", "_blank"}],
           [{"span", [{"class", "hidden-xs"}], _}, name]}
        ]},
       {"td", _, [first_rating]},
       {"td", _, [second_rating]},
       {"td", _, [third_rating]},
       {"td", _, [overall]},
       {"td", _, [price]},
       {"td", _, [num_ratings]}
     ]} = blade_html

    %{
      number_of_ratings: parse_int!(num_ratings),
      overall: parse_revspin_float(overall),
      detail_link: link_for_details,
      model_name: name |> String.trim(),
      price: price |> String.replace_prefix("$", "") |> parse_revspin_float(),
      ratings: {
        parse_revspin_float(first_rating),
        parse_revspin_float(second_rating),
        parse_revspin_float(third_rating)
      }
    }
  end

  def parse_int!(int?) do
    {parsed, ""} = Integer.parse(int?)
    parsed
  end

  defp parse_revspin_float(input) when is_binary(input) do
    input
    |> String.trim()
    |> Float.parse()
    |> case do
      {number, ""} -> number
      :error -> nil
    end
  end
end
