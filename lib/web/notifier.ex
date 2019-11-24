defmodule RevScam.Web.Notifier do
  @behaviour :cowboy_websocket

  @impl true
  def init(request, _) do
    {:cowboy_websocket, request, [], %{:idle_timeout => 300_000}}
  end

  @impl true
  def websocket_init(_) do
    message = format_message("remaining_update", RevScam.Queue.get_queue_size())
    Process.send_after(self(), :update, 1000)
    {[{:text, message}], %{}}
  end

  @impl true
  def websocket_handle(_frame, state) do
    {:ok, state}
  end

  @impl true
  def websocket_info(:update, state) do
    message = format_message("remaining_update", RevScam.Queue.get_queue_size())
    Process.send_after(self(), :update, 1000)
    {:reply, {:text, message}, state}
  end

  defp format_message(action, payload) do
    %{
      "action" => action,
      "payload" => payload
    }
    |> Jason.encode!()
  end
end
