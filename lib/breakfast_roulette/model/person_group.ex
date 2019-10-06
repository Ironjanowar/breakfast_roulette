defmodule BreakfastRoulette.Model.PersonGroup do
  use BreakfastRoulette.Model.Schema
  import Ecto.Changeset

  schema "people_groups" do
    field(:person_id, :id)
    field(:group_id, :id)

    timestamps()
  end

  @doc false
  def changeset(pg, attrs \\ %{}) do
    pg
    |> cast(attrs, [:person_id, :group_id])
    |> validate_required([:person_id, :group_id])
  end
end
