defmodule TimeTravelWeb.Components.Stateful.CreateModal do
  use Phoenix.LiveComponent
  require Logger

  def preload(list_of_assigns) do
    list_of_assigns |> IO.inspect(limit: :infinity, label: "LIST OF ASSIGNS")
  end

  def mount(socket) do
    socket.assigns |> IO.inspect(limit: :infinity, label: "SOCKET ASSIGNS")
    {:ok, socket}
  end

  def update(assigns, socket) do
    Logger.debug(fn -> "assigns: #{inspect(assigns)}" end)
    # this is the default implementation.
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    assigns |> IO.inspect(limit: :infinity, label: "ASSIGNS IN RENDER")

    ~L"""
    <%= if @is_open? do %>
      <section class="modal" test-id="create-modal">
        <section class="modal-content">
          <h3>Book a ticket</h3>
          <form phx-submit="book_ticket">
            <input type="text" name="name" placeholder="Enter traveller name...">
            <input type="text" name="departure" placeholder="Enter Departure date...">
            <input type="text" name="destination" placeholder="Enter Destination date...">
            <section class="buttons">
              <button class="cancel-btn" phx-click="close_modal" phx-target="<%= @myself %>">Cancel</button>
              <button class="save-btn">Save</button>
            </section>
          </form>
        </section>
      </section>
    <% end %>
    """
  end

  @impl true
  # This demos some state, but there is a bug because the button we used to open the modal
  # now wont work....
  def handle_event("close_modal", _, socket) do
    assigns = %{is_open?: false}
    {:noreply, assign(socket, assigns)}
  end
end