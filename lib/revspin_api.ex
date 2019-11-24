defmodule RevScam.RevspinApi do
  use HTTPoison.Base
  @revspin_url "https://revspin.net/"

  def find_links(path) do
    response =
      (@revspin_url <> path <> "/")
      |> get!()

    response.body
  end

  def get_details(link) do
    HTTPoison.get!(@revspin_url <> "/" <> link).body
  end
end
