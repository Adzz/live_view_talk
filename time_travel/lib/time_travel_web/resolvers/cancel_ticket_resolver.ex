defmodule TimeTravelWeb.CancelTicketResolver do
  alias TimeTravel.Ticket
  alias TimeTravelWeb.TicketsResovler.Utils

  def assigns(params) do
    Domain.Request.new(params)
    |> Domain.Request.add_steps([
      &Domain.Request.validate(&1, fn state -> Utils.authorize(state) end),
      &Domain.Request.add_to_state(&1, :ticket, fn state -> Ticket.delete(state) end),
      &TimeTravelWeb.TicketsResovler.Utils.refetch_tickets/1
    ])
    |> Domain.Request.fail_fast()
    |> to_assigns()
  end

  def to_assigns({:error, _changeset}), do: %{}
  def to_assigns(request), do: %{tickets: request.state.tickets}
end
