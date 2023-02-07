defmodule TimeTravelWeb.BookTicketResolver do
  alias TimeTravel.Ticket
  alias TimeTravelWeb.TicketsResovler.Utils

  def assigns(params) do
    Domain.Request.new(params)
    # Pros... simple. Could type Params with a struct or whatever and collect errors easily.
    # Cons. Funs get all the state... Syntax is maybe meh. Is this just objects? Nested stuff is harder.

    # the things we don't like about with are the syntax. And the error handling
    |> Domain.Request.add_steps([
      &Domain.Request.validate(&1, fn state -> Utils.authorize(state) end),
      &Domain.Request.add_to_state(&1, :ticket, fn state -> Ticket.create(state) end),
      &TimeTravelWeb.TicketsResovler.Utils.refetch_tickets/1
    ])
    |> Domain.Request.collect_errors()
    |> to_assigns()
  end

  def to_assigns({:error, _changeset}), do: %{}
  def to_assigns(request), do: %{create_modal_open?: false, tickets: request.state.tickets}
end

halt_on_error = fn fun, data ->
  case fun.(data) do
    {:ok, d} -> {:cont, d}
    %Error{} = e -> {:halt, {:error, e}}
    {:error, e} -> {:halt, {:error, e}}
  end
end

with_tracing = fn fun, data ->
  Logger.info("before")
  result = fun.(data)
  Logger.info("after")

  case result do
    {:ok, d} -> {:cont, d}
    %Error{} = e -> {:halt, {:error, e}}
    {:error, e} -> {:halt, {:error, e}}
  end
end

# The question becomes where is unwind it has to be in acc or in the funs.
# If it's in acc then we get to re-use the same pipeline with a different executor
# that rolls back or not.
# But it means acc (or data really) has to encode the idea of "undo"
# Whereas it feels more natural for the step to be in charge of the fallback.
# You could maybe think of a way for the rollback to be flagged anyway.


with_unwind = fn
fun, data ->

fun, data ->
  case fun.(data) do
    {:ok, d} ->  {:cont, d}
    %Error{} = e -> {:halt, {:error, e}}
    {:error, e} -> {:halt, {:error, e}}
  end
end

pipeline = [&first_fun/1, &second_fun/1, &third_fun/1]

# If we want rollbacks we need to not do the reduce while.
# We need to be able to break our of the loop and start a new one.

pipeline_with_rollback = [
  {&first_fun/1, &undo_1/2},
  {&second_fun/1, &undo_2/2},
  &third_fun/1
]

Enum.reduce_while(pipeline, data, halt_on_error)
Enum.reduce_while(pipeline, data, with_tracing)

Enum.reduce_while(pipeline, data, executor)






