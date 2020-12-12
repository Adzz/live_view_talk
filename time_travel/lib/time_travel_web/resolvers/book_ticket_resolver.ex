defmodule TimeTravelWeb.BookTicketResolver do
  alias TimeTravel.Ticket

  def assigns(params) do
    # So now I'm going to introduce a Domain.Request
    # We can think of the request as being like this:
    # %Domain.Request{
    #   state: params,
    #   # The rules are each step gets and returns a Domain.Request.
    #   steps: [
    #     fn request ->
    #       with {:ok, result} <- Ticket.create(request.state) do
    #         %{request | state: Map.put(request.state, :ticket, result)}
    #       end
    #     end
    #   ]
    # }

    # Now we have options here - we could fail as soon as something errors
    # Or we could collect up errors for later, like changesets, or we can
    # run an on_error like Sagas. We can even combine - run a compensating function
    # and still continue or not based on the result of that... endless possibilities.
    # fail fast is really just a reduce_while which stops on an error.
    # |> Domain.Request.fail_fast()

    # There are two kinds of steps in general. Validation steps and what I called actions for want of a better word.
    # Validations validate some subset of request state
    # Actions do things based off of it. Like add things to request state, talk to the db etc etc.

    # In our case we want to add a ticket and return all new tickets, so we are going to add two
    # actions one to create and one to refetch the tickets

    # Now the actual API we do this, because we want some encapsulation and info hiding:
    Domain.Request.new(params)
    # Elixir syntax gets in the way a bit here because we can't do nested captures.
    |> Domain.Request.add_steps([
      &Domain.Request.add_to_state(&1, :ticket, fn state -> Ticket.create(state) end),
      &TimeTravelWeb.TicketsResovlerUtils.refetch_tickets/1
    ])
    |> Domain.Request.fail_fast()
    |> to_assigns()
  end

  def to_assigns({:error, _changeset}), do: %{}
  def to_assigns(request), do: %{create_modal_open?: false, tickets: request.state.tickets}
end
