defmodule RevScam.Queue do
  @queue_name "consumer_queue"

  def enqueue_job(type, link) do
    Exq.enqueue(Exq, @queue_name, RevScam.DetailsImporter, %{
      type: type,
      link: link
    })
  end
end
