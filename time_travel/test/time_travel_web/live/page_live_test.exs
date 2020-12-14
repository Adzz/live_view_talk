defmodule TimeTravelWeb.PageLiveTest do
  use TimeTravelWeb.ConnCase

  import Phoenix.LiveViewTest

  # Now we can obviously end up writing some very brittle tests if we aren't
  # careful. But we can also do very high level integration tests that allow
  # us to assert on the markup etc. Which is pretty cool!

  test "We can open the modal", %{conn: conn} do
    {:ok, view, html} = live(conn, "/")
    # html |> IO.inspect(limit: :infinity, label: "HTML")

    assert html =~ "Time Travel Tickets</h1>"

    # Open the modal
    html =
      view
      |> element("[test-id=\"modal-open-btn\"]")
      |> render_click()

    # We can see the modal component!
    assert html =~ "test-id=\"create-modal\">"
  end
end
