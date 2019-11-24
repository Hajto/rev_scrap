defmodule RevScam.Queue do
  @queue_name "consumer_queue"

  def enqueue_job(type, link) do
    Exq.enqueue(Exq, @queue_name, RevScam.DetailsImporter, %{
      type: type,
      link: link
    })
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
