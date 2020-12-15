defmodule TimeTravelWeb.Components.Stateful.CreateModal do
  use Phoenix.LiveComponent
  require Logger

  @impl true
  def preload(list_of_assigns) do
    list_of_assigns |> IO.inspect(limit: :infinity, label: "LIST OF ASSIGNS")
  end

  @impl true
  def mount(socket) do
    socket.assigns |> IO.inspect(limit: :infinity, label: "SOCKET ASSIGNS")
    {:ok, assign(socket, %{return?: false})}
  end

  @impl true
  def update(assigns, socket) do
    Logger.debug(fn -> "assigns: #{inspect(assigns)}" end)
    # this is the default implementation.
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    assigns |> IO.inspect(limit: :infinity, label: "ASSIGNS IN RENDER")

    ~L"""
    <section class="modal" test-id="create-modal">
      <section class="modal-content">
        <h3>Book a ticket</h3>
        <form phx-submit="book_ticket">
          <input type="text" name="name" placeholder="Enter traveller name...">
          <input type="text" name="departure" placeholder="Enter Departure date...">
          <input type="text" name="destination" placeholder="Enter Destination date...">

          <button phx-click="toggle_return" phx-target="<%= @myself %>">Return?</button>
          <%= if @return? do %>
            <input type="text" name="return_date" placeholder="Enter time you wish to return to now">
          <% end %>
          <section class="buttons">
            <button class="cancel-btn" phx-click="close_modal">Cancel</button>
            <button class="save-btn">Save</button>
          </section>
        </form>
      </section>
    </section>
    """
  end

  @impl true
  def handle_event("toggle_return", _, socket) do
    assigns = %{return?: !socket.assigns.return?}
    {:noreply, assign(socket, assigns)}
  end
end