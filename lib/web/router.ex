defmodule RevScam.Web.Router do
  use Plug.Router
  require EEx

  plug(Plug.Static,
    at: "/",
    from: :revscam
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_file(conn, 200, "priv/static/index.html")
  end

  get "/start_sync" do
    if RevScam.Queue.get_queue_size() == 0 do
      RevScam.sync()
    end

    send_file(conn, 200, "priv/static/index.html")
  end

  get "/stop" do
    Exq.Api.remove_queue(Exq.Api, "consumer_queue")
    send_resp(conn, 200, "Ok")
  end

  match _ do
    send_resp(conn, 404, "404")
  end
end
