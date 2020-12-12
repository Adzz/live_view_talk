defmodule TimeTravel.Repo.Migrations.CreateTicketsTable do
  use Ecto.Migration

  def change do
    create(table("tickets")) do
      add(:name, :text, null: false)
      add(:departure, :text, null: false)
      add(:destination, :text, null: false)
      timestamps()
    end
  end
end
