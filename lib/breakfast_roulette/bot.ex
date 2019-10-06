defmodule BreakfastRoulette.Bot do
  @bot :breakfast_roulette

  use ExGram.Bot,
    name: @bot

  alias BreakfastRoulette.Model.Person
  alias BreakfastRoulette.Model.Group

  require Logger

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, "start", msg}, context) do
    tg_user = %{
      first_name: msg.chat.first_name,
      last_name: msg.chat.last_name,
      telegram_id: to_string(msg.chat.id),
      username: msg.chat.username
    }

    case Person.create_person(tg_user) do
      {:ok, user} -> answer(context, "Hi #{user.first_name}!")
      {:error, error} -> answer(context, error)
    end
  end

  def handle({:command, "create", %{text: ""}}, context) do
    msg_groups =
      Group.get_groups()
      |> Enum.map(fn g -> Group.view(g, :text) end)
      |> Enum.join("\n")

    answer(context, "Group list: \n#{msg_groups}")
  end

  def handle({:command, "create", %{text: name}}, context) do
    msg |> inspect |> Logger.info()

    case Group.create_group(%{group_name: name}) do
      {:ok, newGroup} -> answer(context, "Group #{newGroup} created!")
      {:error, _error} -> answer(context, "Woops")
    end
  end

  def handle({:command, "join", %{text: ""}}, context) do
    answer(context, "Please, join a group by saying its name")
  end

  def handle({:command, "join", %{text: name}}, context) do
    # TODO: update many-to-many relations
  end
end
