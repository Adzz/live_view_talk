defmodule TimeTravelWeb.PageLive do
  use TimeTravelWeb, :live_view
  require Logger
  alias TimeTravelWeb.Components.Button

  @impl true
  # A plug further up puts the token in.
  def mount(_params, session, socket) do
    # in reality we would not do this obviously:
    session = %{"user_token" => "hi"}

    with %{"user_token" => token} <- session do
      assigns = %{
        create_modal_open?: false,
        tickets: TimeTravel.Ticket.all(),
        user: TimeTravel.User.get_user_by_session_token(token)
      }

      {:ok, assign(socket, assigns)}
    else
      _ -> raise "Nope!"
    end
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
    state = Map.merge(params, %{"user" => socket.assigns.user})
    assigns = TimeTravelWeb.BookTicketResolver.assigns(state)
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("cancel_ticket", params, socket) do
    state = Map.merge(params, %{"user" => socket.assigns.user})
    assigns = TimeTravelWeb.CancelTicketResolver.assigns(state)
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
