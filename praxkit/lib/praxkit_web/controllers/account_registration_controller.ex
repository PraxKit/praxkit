defmodule PraxkitWeb.AccountRegistrationController do
  use PraxkitWeb, :controller

  alias Praxkit.Accounts
  alias Praxkit.Accounts.Account

  def new(conn, _params) do
    changeset = Accounts.change_account_registration(%Account{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"account" => account_params}) do
    case Accounts.create_account(account_params) do
      {:ok, %{users: [user]} = _account} ->
        PowEmailConfirmation.Ecto.Context.confirm_email(user, %{}, otp_app: :praxkit)
        {conn, _user} = Pow.Plug.Session.create(conn, user, otp_app: :praxkit)
        # TODO: Add text about changing this to require email confirmation

        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: Routes.app_home_path(conn, :index))
        # |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
