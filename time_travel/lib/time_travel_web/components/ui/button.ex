defmodule TimeTravelWeb.Components.UI.Button do
  import Phoenix.LiveView.Helpers

  @doc """
  A simple UI button.
  """
  def tag(assigns = %{on_click: on_click, button_text: button_text}) do
    test_id = Map.get(assigns, :test_id,  "button")
    assigns = %{on_click: on_click, button_text: button_text, test_id: test_id}

    # In react you would sometimes pass rest. Which isn't really a thing here.
    ~L"""
    <button test-id="<%= @test_id %>" phx-click="<%= @on_click %>">
      <%= @button_text %>
    </button>
    """
  end
end
