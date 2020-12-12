defmodule TimeTravel.Ticket do
  alias TimeTravel.Schemas.Ticket

  def create(params) do
    TimeTravel.Repo.insert(create_changeset(params))
  end

  defp create_changeset(changes) do
    Ecto.Changeset.cast(%Ticket{}, changes, Ticket.__schema__(:fields))
    |> Ecto.Changeset.validate_required([:name, :departure, :destination])
  end

  def delete(%{"id" => id}) do
    TimeTravel.Repo.delete(%Ticket{id: id})
  end

  def all() do
    TimeTravel.Repo.all(TimeTravel.Schemas.Ticket)
  end
end
