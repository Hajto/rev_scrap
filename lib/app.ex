defmodule RevScam.App do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RevScam.Repo,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: RevScam.Web.Router,
        options: [port: 4000, dispatch: dispatch()],
        otp_app: :revscam
      )
    ]

    opts = [strategy: :one_for_one, name: RevScam.App]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/status", RevScam.Web.Notifier, []},
         {:_, Plug.Cowboy.Handler, {RevScam.Web.Router, []}}
       ]}
    ]
  end
end
