defmodule PraxkitWeb.App.Notifications.SidebarLiveTest do
  use PraxkitWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias PraxkitWeb.App.Notifications.SidebarLive
  alias Praxkit.InAppNotifications

  describe "logged in" do
    setup [:register_and_log_in_user]

    test "disconnected and connected render", %{conn: conn} do
      {:ok, view, disconnected_html} = live_isolated(conn, SidebarLive)
      assert disconnected_html =~ "There are no notifications for now."
      assert render(view) =~ "There are no notifications for now."
    end

    test "with an unread notification", %{conn: conn, user: user} do
      InAppNotifications.create_notification(user, %{type: "info", title: "My notification title", body: "My notification body"})
      {:ok, view, _html} = live_isolated(conn, SidebarLive)
      assert render(view) =~ "My notification title"
      refute render(view) =~ "There are no notifications for now."
    end
  end
end
