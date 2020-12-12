defmodule TimeTravelWeb.CancelTicketResolver do
  alias TimeTravel.Ticket

  # The benefit of having this resolver, rather than having this stuff live in the PageLive
  # module is that now we can call it from a anywhere. What if we have a cron route triggered
  # via a webhook, now our controller can just call this, sending in the right params. Yay.

  def assigns(params) do
    with {:ok, _ticket} <- Ticket.delete(params) do
      %{tickets: Ticket.all()}
    else
      {:error, _changeset} -> %{}
    end
  end
end
