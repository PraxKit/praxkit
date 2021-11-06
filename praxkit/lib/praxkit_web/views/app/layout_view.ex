defmodule PraxkitWeb.App.LayoutView do
  use PraxkitWeb, :view
  import Phoenix.LiveView.Helpers

  alias PraxkitWeb.App

  def flash_component(conn, current_user) do
    live_render(conn, PraxkitWeb.FlashLive,
      session: %{
        "app_channel" => "app:#{current_user.channel_name}",
        "info" => get_flash(conn, :info),
        "error" => get_flash(conn, :error)
      }
    )
  end

  def notification_indicator(conn, current_user) do
    live_render(conn, App.Notifications.IndicatorLive,
      session: %{"user_id" => current_user.id, "account_id" => current_user.account_id}
    )
  end

  def notification_sidebar(conn, current_user) do
    live_render(conn, App.Notifications.SidebarLive,
      session: %{"user_id" => current_user.id, "account_id" => current_user.account_id}
    )
  end
end
