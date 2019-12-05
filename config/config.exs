use Mix.Config

config :revscam, ecto_repos: [RevScam.Repo]

config :revscam, RevScam.Repo,
  database: "revscam",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :exq,
  name: Exq,
  host: "127.0.0.1",
  port: 6379,
  namespace: "revspin",
  concurrency: 5,
  queues: ["consumer_queue"],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 5,
  shutdown_timeout: 5000
