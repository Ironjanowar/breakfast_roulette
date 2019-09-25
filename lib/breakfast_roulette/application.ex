defmodule BreakfastRoulette.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      ExGram,
      {BreakfastRoulette.Bot, [method: :polling, token: token]},
      BreakfastRoulette.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BreakfastRoulette.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
