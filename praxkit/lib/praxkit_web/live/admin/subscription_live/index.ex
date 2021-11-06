defmodule PraxkitWeb.Admin.SubscriptionLive.Index do
  use PraxkitWeb, :live_view_admin
  use Saas.DataTable

  import PraxkitWeb.Views.DateHelpers

  alias Praxkit.Billing

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, get_subscriptions_assigns(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:params, params)
      |> assign(:page_title, "Listing Subscriptions")
      |> assign(get_subscriptions_assigns(params))
    }
  end

  defp get_subscriptions_assigns(params) do
    case Billing.paginate_subscriptions(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
