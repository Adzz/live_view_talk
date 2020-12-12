defmodule TimeTravelWeb.PageLive do
  use TimeTravelWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    assigns = %{
      create_modal: false,
      tickets: [%{name: "ted Bundy", destination: "1973", departure: "now"}]
    }
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event(event, params, socket) do
    event |> IO.inspect(limit: :infinity, label: "EVENT")
    params |> IO.inspect(limit: :infinity, label: "PARAMS")
    Logger.warn("Unrecognised event triggered!")
    {:noreply, socket}
  end
end
