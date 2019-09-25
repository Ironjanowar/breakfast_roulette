defmodule BreakfastRoulette.Bot do
  @bot :breakfast_roulette

  use ExGram.Bot,
    name: @bot

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, "start", _msg}, context) do
    answer(context, "Hi!")
  end
end
