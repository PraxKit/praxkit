defmodule PraxkitWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias PraxkitWeb.Router.Helpers, as: Routes

  def after_sign_in_path(conn), do: Routes.app_home_path(conn, :index)

  def after_sign_out_path(conn), do: Routes.user_session_path(conn, :new)
end
