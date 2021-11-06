defmodule PraxkitWeb.Admin.UserImpersonationController do
  use PraxkitWeb, :controller

  alias Praxkit.Accounts

  def create(conn, %{"account_id" => account_id, "id" => id}) do
    account = Accounts.get_account!(account_id)
    user = Accounts.get_user!(account, id)

    {conn, _user} = Pow.Plug.Session.create(conn, user, otp_app: :praxkit)

    conn
    |> put_flash(:info, "Impersonating user")
    |> redirect(to: Routes.app_home_path(conn, :index))
  end
end
