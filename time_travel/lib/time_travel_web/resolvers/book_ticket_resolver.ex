defmodule TimeTravelWeb.BookTicketResolver do
  alias TimeTravel.Ticket

  def assigns(params) do
    # Usually we might do this:
    with {:ok, _ticket} <- Ticket.create(params) do
      %{create_modal_open?: false, tickets: Ticket.all()}
    else
      {:error, _changeset} -> %{}
    end
  end
end
