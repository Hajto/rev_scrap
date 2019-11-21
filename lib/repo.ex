defmodule RevScam.Repo do
  use Ecto.Repo,
    otp_app: :revscam,
    adapter: Ecto.Adapters.Postgres
end
