defmodule BreakfastRoulette.Model.Person do
  use BreakfastRoulette.Model.Schema

  alias __MODULE__
  alias BreakfastRoulette.Repo
  alias BreakfastRoulette.Model.Group

  import Ecto.Changeset
  import Ecto.Query

  require Logger

  schema "people" do
    field(:telegram_id, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:username, :string)

    many_to_many(:groups, Group, join_through: "people_groups", on_replace: :delete)

    timestamps()
  end

  defp changeset(attrs) do
    %Person{}
    |> cast(attrs, [:telegram_id, :first_name, :last_name, :username])
    |> validate_required([:telegram_id, :first_name])
    |> unique_constraint(:telegram_id)
  end

  @doc """
  Validates and inserts a person into the database
  """
  @spec create_person(map()) :: {:ok, %Person{}} | {:error, String.t()}
  def create_person(attrs) do
    with changeset <- changeset(attrs),
         _ = changeset |> inspect |> Logger.debug(),
         true <- changeset.valid?,
         {:ok, person} <- Repo.insert(changeset) do
      {:ok, person}
    else
      err ->
        err |> inspect |> Logger.error()
        {:error, "There was an error creating the person"}
    end
  end

  @doc """
  Fetches all the people stored on the database
  """
  @spec get_people() :: {:ok, [%Person{}]}
  def get_people() do
    {:ok, from(Person) |> Repo.all()}
  end

  @spec get_person({:id | :username, String.t()}) :: {:ok, %Person{}}
  def get_person({:id, person_id}) do
    Repo.get!(Person, person_id)
  end

  def get_person({:username, username}) do
    Repo.get_by!(Person, username: username)
  end
end
