defmodule RevScam.RevspinApi do
  use HTTPoison.Base
  @revspin_url "https://revspin.net/"

  def find_links(path) do
    %HTTPoison.Response{status_code: 200, body: body} =
      (@revspin_url <> path <> "/")
      |> get!()

    body
  end

  def get_details(link) do
    %HTTPoison.Response{status_code: 200, body: body} =
      HTTPoison.get!(@revspin_url <> "/" <> link)

    body
  end
end
