defmodule TimeTravelWeb.CancelTicketResolver do
  alias TimeTravel.Ticket

  # The benefit of having this resolver, rather than having this stuff live in the PageLive
  # module is that now we can call it from a anywhere. What if we have a cron route triggered
  # via a webhook, now our controller can just call this, sending in the right params. Yay.

  def assigns(params) do
    Domain.Request.new(params)
    |> Domain.Request.add_steps([
      &Domain.Request.add_to_state(&1, :ticket, fn state -> Ticket.delete(state) end),
      &TimeTravelWeb.TicketsResovlerUtils.refetch_tickets/1
    ])
    |> Domain.Request.fail_fast()
    |> to_assigns()
  end

  def to_assigns({:error, _changeset}), do: %{}
  def to_assigns(request), do: %{tickets: request.state.tickets}
end
