use Mix.Config

config :revscam, ecto_repos: [RevScam.Repo]

config :revscam, RevScam.Repo,
  database: "ecto_simple",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
