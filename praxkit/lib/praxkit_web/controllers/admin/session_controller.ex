defmodule PraxkitWeb.Admin.SessionController do
  use PraxkitWeb, :controller

  alias Praxkit.{Admins, Admins.Guardian}

  plug PraxkitWeb.Plugs.RedirectAdmin when action in [:new, :create]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"admin" => %{"email" => email, "password" => password}}) do
    Admins.Auth.authenticate_admin(email, password)
    |> login_reply(conn)
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()                            # This module's full name is Auth.UserManager.Guardian.Plug,
    |> redirect(to: Routes.admin_session_path(conn, :new)) # and the arguments specfied in the Guardian.Plug.sign_out()
  end                                                      # docs are not applicable here

  defp login_reply({:ok, admin}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(admin)                            # This module's full name is Auth.UserManager.Guardian.Plug,
    |> redirect(to: Routes.admin_dashboard_index_path(conn, :index)) # and the arguments specified in the Guardian.Plug.sign_in()
  end                                                          # docs are not applicable here.

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
