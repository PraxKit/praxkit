defmodule <%= inspect context.web_module %>.<%= inspect Module.concat(schema.web_namespace, schema.alias) %>Live.Show do
  use <%= inspect context.web_module %>, :live_view_admin

  alias <%= inspect context.module %>
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
     |> assign(:<%= schema.singular %>, <%= inspect context.alias %>.get_<%= schema.singular %>!(account, id))}
  end

  defp page_title(:show), do: "Show <%= schema.human_singular %>"
  defp page_title(:edit), do: "Edit <%= schema.human_singular %>"
end
