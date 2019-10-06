defmodule BreakfastRoulette.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:group_name, :string)

      timestamps()
    end

    create table(:people_groups, primary_key: false) do
      add(:person_id, references(:people, on_delete: :delete_all, type: :uuid), primary_key: true)
      add(:group_id, references(:groups, on_delete: :delete_all, type: :uuid), primary_key: true)

      timestamps()
    end

    create(index(:people_groups, [:person_id]))
    create(index(:people_groups, [:group_id]))

    create(unique_index(:people_groups, [:person_id, :group_id]))
  end
end
