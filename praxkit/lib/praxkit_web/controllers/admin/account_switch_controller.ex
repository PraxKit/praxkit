defmodule PraxkitWeb.Admin.AccountSwitchController do
  use PraxkitWeb, :controller

  alias Praxkit.Accounts

  def create(conn, %{"token" => token}) do
    account = Accounts.get_account_by_token!(token)

    conn
    |> put_session(:admin_account_id, account.id)
    |> put_flash(:info, "Account changed")
    |> redirect(to: Routes.admin_dashboard_index_path(conn, :index))
  end
end
