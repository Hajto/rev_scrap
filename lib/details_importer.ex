defmodule RevScam.DetailsImporter do
  def import(type, link) do
    data = RevScam.RevspinApi.get_details(link)
  end
end
