defmodule RevScam.RevspinApi do
  use HTTPoison.Base
  @revspin_url "https://revspin.net/"
  @ignored_brands ["armstrong"]

  def find_links(path) do
    (@revspin_url <> path <> "/")
    |> process_list_endpoint()
    |> Enum.map(fn {brand, entries} ->
      entries =
        Floki.find(entries, "tr")
        |> Enum.drop(1)
        |> Enum.map(&parse_entry_for_link/1)

      {brand, entries}
    end)
  end

  defp parse_entry_for_link(entry_html) do
    [{"a", attributes, _children}] = Floki.find(entry_html, "a")
    {"href", link} = List.keyfind(attributes, "href", 0)
    link
  end

  defp process_list_endpoint(endpoint) do
    response = HTTPoison.get!(endpoint)

    Floki.find(response.body, ".max-xxs")
    |> Enum.map(fn {"div", attributes, _children} = tag ->
      case :lists.keyfind("id", 1, attributes) do
        {"id", <<"brand-", id::binary>>} when id not in @ignored_brands -> {id, tag}
        _ -> false
      end
    end)
    |> Enum.filter(&match?({_, _}, &1))
  end
end
