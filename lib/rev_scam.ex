defmodule RevScam do
  def sync() do
    ["blade", "rubber"]
    |> Enum.each(fn type ->
      RevScam.RevspinApi.find_links(type)
      |> RevScam.RevspinParser.parse_links()
      |> Enum.each(fn {brand, links} ->
        Enum.each(links, fn link ->
          RevScam.Queue.enqueue_job(brand, type, link)
        end)
      end)
    end)
  end
end
