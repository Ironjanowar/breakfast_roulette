# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :breakfast_roulette, BreakfastRoulette.Repo,
  database: System.get_env("PGDATABASE"),
  username: System.get_env("PGUSER"),
  password: System.get_env("PGPASSWORD"),
  hostname: System.get_env("PGHOST"),
  port: System.get_env("PGPORT")

config :breakfast_roulette, ecto_repos: [BreakfastRoulette.Repo]

config :ex_gram,
  token: {:system, "BOT_TOKEN"}
