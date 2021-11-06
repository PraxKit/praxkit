defmodule PraxkitWeb.App.TeamLive.Index do
  use PraxkitWeb, :live_view

  alias Praxkit.Accounts

  on_mount PraxkitWeb.App.InitAssigns

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users(socket.assigns.account)

    {
      :ok,
      socket
      |> assign(:users, users)
    }
  end
end
