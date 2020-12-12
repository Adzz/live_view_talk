defmodule TimeTravelWeb.PageLive do
  use TimeTravelWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    assigns = %{
      create_modal: false,
      tickets: []
    }
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("create", %{"q" => query}, socket) do
  end
end
