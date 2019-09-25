defmodule BreakfastRoulette.MixProject do
  use Mix.Project

  def project do
    [
      app: :breakfast_roulette,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {BreakfastRoulette.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, github: "rockneurotiko/ex_gram", branch: "master"},
      {:ecto_sql, "~> 3.2"},
      {:postgrex, "~> 0.15.1"},
      {:jason, "~> 1.1"}
    ]
  end
end
