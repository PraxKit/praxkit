defmodule PraxkitWeb.App.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """

  import Phoenix.LiveView
  alias Praxkit.Accounts

  def on_mount(:default, _params, %{"current_account_id" => account_id, "current_user_id" => user_id}, socket) do
    account = Accounts.get_account!(account_id)
    user = Accounts.get_user!(account, user_id)

    {
      :cont,
      socket
      |> assign(:account, account)
      |> assign(:user, user)
    }
  end

  def on_mount(:default, _params, _session, socket) do
    {:halt, redirect(socket, to: "/sign_in")}
  end
end
