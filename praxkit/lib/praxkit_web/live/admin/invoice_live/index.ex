defmodule PraxkitWeb.Admin.InvoiceLive.Index do
  use PraxkitWeb, :live_view_admin
  use Saas.DataTable

  import PraxkitWeb.Views.DateHelpers
  import PraxkitWeb.Views.NumberHelpers

  alias Praxkit.Billing

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, get_invoices_assigns(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:params, params)
      |> assign(:page_title, "Listing Invoices")
      |> assign(get_invoices_assigns(params))
    }
  end

  defp get_invoices_assigns(params) do
    case Billing.paginate_invoices(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
