defmodule TimeTravelWeb.BookTicketResolver do
  alias TimeTravel.Ticket

  # The benefit of having this resolver, rather than having this stuff live in the PageLive
  # module is that now we can call it from a anywhere. What if we have a cron route triggered
  # via a webhook, now our controller can just call this, sending in the right params. Yay.

  # Graphql aside.
  # In absinthe you'll often see people handle authorization in middleware, which has the
  # benefit of being applied for all absinthe requests, but the drawback that it spreads the
  # business logic around the app. And it cannot be leveraged from outside of absinthe.

  def assigns(params) do
    with {:ok, _ticket} <- Ticket.create(params) do
      %{create_modal_open?: false, tickets: Ticket.all()}
    else
      {:error, _changeset} -> %{}
    end
  end
end
