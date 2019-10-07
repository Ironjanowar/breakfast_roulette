defmodule BreakfastRoulette.Bot do
  @bot :breakfast_roulette

  use ExGram.Bot,
    name: @bot

  # alias BreakfastRoulette.Repo
  alias BreakfastRoulette.Model.Person
  alias BreakfastRoulette.Model.Group
  alias BreakfastRoulette.Model.PersonGroup

  require Logger

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, "start", msg}, context) do
    tg_user = %{
      first_name: msg.chat.first_name,
      # last_name: msg.chat.last_name,
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
    case Group.create_group(%{group_name: name}) do
      {:ok, newGroup} -> answer(context, "Group #{newGroup} created!")
      {:error, _error} -> answer(context, "Woops")
    end
  end

  def handle({:command, "join", %{text: ""}}, context) do
    answer(context, "Please, join a group by saying its name")
  end

  def handle({:command, "join", %{chat: %{username: username}, text: name}}, context) do
    person = Person.get_person({:username, username})
    group = Group.get_group({:name, name})
    PersonGroup.add(person.id, group.id)
    answer(context, "Enjoy your breakfasts!")
  end

  def handle({:command, "call", %{chat: %{username: username}, text: name}}, context) do
    Group.get_group({:name, name}).people
    |> Enum.filter(fn p -> p.username != username end)
    |> Enum.map(fn p -> ExGram.send_message(p.username, "Join the breakfast with #{name}!") end)

    answer(context, "Everyone has been called :D")
  end
end
