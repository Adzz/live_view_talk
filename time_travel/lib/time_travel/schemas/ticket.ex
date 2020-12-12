defmodule TimeTravel.Schemas.Ticket do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tickets" do
    field(:name, :string)
    field(:departure, :string)
    field(:destination, :string)
    timestamps()
  end
end
