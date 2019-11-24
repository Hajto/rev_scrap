defmodule RevScam.RevspinParser do
  @rubber_props [
    "speed",
    "spin",
    "control",
    "tackiness",
    "weight",
    "sponge_hardness",
    "gears",
    "throw_angle",
    "consistency",
    "durability"
  ]

  @blade_props ["speed", "control", "stiffness", "hardness", "consistency"]

  def parse_rubber_details(html) do
    common_props = extract_common_props(html)

    @rubber_props
    |> parse_expected_props(Floki.find(html, "#UserRatingsTable tr"))
    |> Map.merge(common_props)
  end

  def parse_blade_details(html) do
    common_props = extract_common_props(html)

    @blade_props
    |> parse_expected_props(Floki.find(html, "#UserRatingsTable tr"))
    |> Map.merge(common_props)
  end

  defp parse_expected_props(prop_names, trs) do
    prop_names
    |> Enum.zip(trs)
    |> Enum.map(fn {prop_name, tr} ->
      {prop_name |> String.to_atom(), extract_value(prop_name, tr) |> parse_revspin_float()}
    end)
    |> Enum.into(%{})
  end

  defp extract_common_props(item_html) do
    [{"span", _, [{"span", _, [overall]} | _]}] =
      Floki.find(item_html, "span[itemprop=\"ratingValue\"]")

    %{
      name: extract_name(item_html),
      overall: overall |> parse_revspin_float(),
      ratings: parse_ratings(item_html),
      price: parse_price(item_html)
    }
  end

  defp extract_value(expected_property_name, html) do
    {"tr", _,
     [
       {"td", _, [property_name | _]},
       {"td", _, [value | _]}
     ]} = html

    property_name =
      property_name |> String.trim() |> String.downcase() |> String.replace(" ", "_")

    if expected_property_name != property_name do
      raise "Expected different property, got #{property_name} expected #{expected_property_name}"
    end

    value
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

  defp extract_name(item_html) do
    [{"h1", _, [name]}] = Floki.find(item_html, "h1[itemprop=\"name\"]")
    name
  end

  defp parse_ratings(item_html) do
    [{"span", _, [review_count]}] = Floki.find(item_html, "span[itemprop=\"reviewCount\"]")
    review_count |> parse_int!()
  end

  defp parse_price(item_html) do
    [{"span", _, [price]}] = Floki.find(item_html, "#actual_price")
    price |> parse_revspin_float()
  end
end
