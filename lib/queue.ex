defmodule RevScam.Queue do
  @queue_name "consumer_queue"

  def enqueue_job(brand, type, link) do
    Exq.enqueue(Exq, @queue_name, RevScam.DetailsImporter, [brand, type, link])
  end

  def get_queue_size() do
    {:ok, size} = Exq.Api.queue_size(Exq.Api, "consumer_queue")
    size
  end
end
