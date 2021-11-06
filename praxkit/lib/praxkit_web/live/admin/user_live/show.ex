defmodule PraxkitWeb.Admin.UserLive.Show do
  use PraxkitWeb, :live_view_admin

  alias Praxkit.Accounts

  @impl true
  def mount(_params, %{"admin_account_id" => account_id} = _session, socket) do
    account = Accounts.get_account!(account_id)
    {:ok, assign(socket, :account, account)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    account = socket.assigns.account

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user, Accounts.get_user!(account, id))}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
