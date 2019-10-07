defmodule BreakfastRoulette.Model.Group do
  use BreakfastRoulette.Model.Schema

  alias __MODULE__
  alias BreakfastRoulette.Repo
  alias BreakfastRoulette.Model.Person

  import Ecto.Changeset

  require Logger

  schema "groups" do
    field(:group_name, :string)

    many_to_many(:people, Person, join_through: "people_groups", on_replace: :delete)

    timestamps()
  end

  defp changeset(attrs) do
    %Group{}
    |> cast(attrs, [:group_name])
    |> validate_required([:group_name])
  end

  defimpl String.Chars, for: Group do
    @spec to_string(Group) :: String.t()
    def to_string(group), do: "#{group.group_name}"
  end

  @spec create_group(map()) :: {:ok, %Group{}} | {:error, String.t()}
  def create_group(attrs) do
    with changeset <- changeset(attrs),
         true <- changeset.valid?,
         {:ok, group} <- Repo.insert(changeset) do
      {:ok, group}
    else
      err ->
        err |> inspect |> Logger.error()
        {:error, "There was an error creating the group"}
    end
  end

  @spec get_groups() :: [%Group{}]
  def get_groups() do
    Repo.all(Group) |> Repo.preload(:people)
  end

  @spec get_group({:id | :name, String.t()}) :: {:ok, %Person{}}
  def get_group({:id, group_id}) do
    Repo.get!(Group, group_id)
  end

  def get_group({:name, group_name}) do
    Repo.get_by!(Group, group_name: group_name) |> Repo.preload(:people)
  end

  @spec view(%Group{}, :text) :: String.t()
  def view(group, :text) do
    "#{group.group_name} (#{length(group.people)}p.)"
  end
end
