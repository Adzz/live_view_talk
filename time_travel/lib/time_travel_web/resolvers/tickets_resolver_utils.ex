defmodule TimeTravelWeb.TicketsResovlerUtils do
  alias TimeTravel.Ticket

  def refetch_tickets(req) do
    Domain.Request.add_to_state(req, :tickets, fn _ -> {:ok, Ticket.all()} end)
  end
end