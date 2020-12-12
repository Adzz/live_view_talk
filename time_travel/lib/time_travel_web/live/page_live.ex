defmodule TimeTravelWeb.PageLive do
  use TimeTravelWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    assigns = %{
      create_modal_open?: false,
      tickets: TimeTravel.Ticket.all()
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
    assigns = TimeTravelWeb.BookTicketResolver.assigns(params)
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("cancel_ticket", params, socket) do
    assigns = TimeTravelWeb.CancelTicketResolver.assigns(params)
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
