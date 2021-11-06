defmodule PraxkitWeb.Admin.UserLive.Index do
  use PraxkitWeb, :live_view_admin
  use Saas.DataTable

  alias Praxkit.Accounts
  alias Praxkit.Accounts.User

  @impl true
  def mount(_params, %{"admin_account_id" => account_id} = _session, socket) do
    account = Accounts.get_account!(account_id)
    {:ok, assign(socket, :account, account)}
  end
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> put_flash(:error, "You need to switch to an account first")
      |> push_redirect(to: Routes.admin_account_index_path(socket, :index))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:params, params)
      |> assign(get_users_assigns(socket.assigns.account, params))
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, params) do
    account = socket.assigns.account

    socket
    |> assign(:page_title, "Listing Users")
    |> assign(:user, nil)
    |> assign(get_users_assigns(account, params))
    |> assign(:params, params)
  end

  defp apply_action(socket, :notify, %{"id" => id}) do
    account = socket.assigns.account

    socket
    |> assign(:page_title, "Notify User")
    |> assign(:user, Accounts.get_user!(account, id))
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    account = socket.assigns.account
    user = Accounts.get_user!(account, id)
    {:ok, _} = Accounts.delete_user(user)

    {:noreply, assign(socket, get_users_assigns(account, %{}))}
  end

  defp get_users_assigns(account, params) do
    case Accounts.paginate_users(account, params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
