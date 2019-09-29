defmodule BreakfastRoulette.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")

    create table(:people, primary_key: false) do
      add(:id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:telegram_id, :string, null: false)
      add(:first_name, :string, null: false)
      add(:last_name, :string)
      add(:username, :string)
    end

    create(unique_index(:people, [:telegram_id]))
  end
end
