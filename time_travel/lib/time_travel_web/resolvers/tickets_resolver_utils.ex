defmodule TimeTravelWeb.TicketsResovler.Utils do
  alias TimeTravel.Ticket

  def refetch_tickets(req) do
    Domain.Request.add_to_state(req, :tickets, fn _ -> {:ok, Ticket.all()} end)
  end

  def authorize(%{"user" => %{email: "bundy@aol.net"}}), do: {:ok, true}
  def authorize(_), do: {:error, false}
end
