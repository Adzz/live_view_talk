defmodule TimeTravelWeb.PageLive do
  use TimeTravelWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    assigns = %{
      create_modal_open?: false,
      tickets: [%{name: "ted Bundy", destination: "1973", departure: "now"}]
    }

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("open_modal", _, socket) do
    assigns = %{create_modal_open?: true}
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("close_modal", _, socket) do
    assigns = %{create_modal_open?: false}
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("book_ticket", params, socket) do
    # Now traditionally you would introduce a Phoenix Context here.
    # That's essentially a place to co-locate all the business logic for
    # a particular action or entity. Let's look at that approach.

    # I'm introducing a resolver here who's job it is to return assigns
    # for the given action - successful or not.
    assigns = TimeTravelWeb.BookTicketResolver.assigns(params)
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event(event, params, socket) do
    event |> IO.inspect(limit: :infinity, label: "EVENT")
    params |> IO.inspect(limit: :infinity, label: "PARAMS")
    Logger.warn("Unrecognised event triggered!")
    {:noreply, socket}
  end
end
