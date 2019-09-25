defmodule BreakfastRoulette.Repo do
  use Ecto.Repo,
    otp_app: :breakfast_roulette,
    adapter: Ecto.Adapters.Postgres
end
