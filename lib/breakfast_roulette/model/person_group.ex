defmodule BreakfastRoulette.Model.PersonGroup do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias BreakfastRoulette.Repo
  alias BreakfastRoulette.Model.Person
  alias BreakfastRoulette.Model.Group

  @primary_key false
  @foreign_key_type :binary_id
  schema "people_groups" do
    belongs_to(:person, Person, primary_key: true)
    belongs_to(:group, Group, primary_key: true)

    timestamps()
  end

  @doc false
  def changeset(pg, attrs \\ %{}) do
    pg
    |> cast(attrs, [:person_id, :group_id])
    |> validate_required([:person_id, :group_id])
    |> foreign_key_constraint(:person_id)
    |> foreign_key_constraint(:group_id)

    # |> unique_constraint([:person_id, :group_id])
  end

  def add(person_id, group_id) do
    changeset(%PersonGroup{}, %{person_id: person_id, group_id: group_id})
    |> Repo.insert()
  end
end
