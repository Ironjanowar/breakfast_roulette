defmodule BreakfastRoulette.Bot do
  @bot :breakfast_roulette

  use ExGram.Bot,
    name: @bot

  alias BreakfastRoulette.Model.Person

  require Logger

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, "start", _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, "register", %{from: tg_user}}, context) do
    tg_user |> inspect |> Logger.debug()

    tg_user = tg_user |> Map.put(:telegram_id, tg_user[:id] |> to_string) |> Map.delete(:id)

    case Person.create_person(tg_user) do
      {:ok, user} -> answer(context, "User #{user.first_name} created")
      {:error, error} -> answer(context, error)
    end
  end
end
