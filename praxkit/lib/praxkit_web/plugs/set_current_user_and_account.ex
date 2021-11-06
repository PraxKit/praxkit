defmodule PraxkitWeb.Plugs.SetCurrentUserAndAccount do
  import Plug.Conn, only: [assign: 3, put_session: 3]

  alias Praxkit.Accounts
  alias Praxkit.Accounts.User

  def init(options), do: options

  # TODO: Test
  def call(conn, _opts) do
    case Pow.Plug.current_user(conn) do
      %User{} = user ->
        %{account: account} = Accounts.with_account(user)
        conn
        |> assign(:current_account, account)
        |> put_session(:current_account_id, account.id)
        |> put_session(:current_user_id, user.id)
      _ -> conn
    end
  end
end
