defmodule BreakfastRoulette.Model.Person do
  use Ecto.Schema

  alias __MODULE__
  alias BreakfastRoulette.Repo

  import Ecto.Changeset
  import Ecto.Query

  require Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "people" do
    field(:telegram_id, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:username, :string)
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
end
