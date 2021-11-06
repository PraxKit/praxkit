defmodule PraxkitWeb.Admin.BackgroundJobLive.Index do
  use PraxkitWeb, :live_view_admin
  use Saas.DataTable

  alias Praxkit.BackgroundJobs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:params, params)
      |> assign(get_jobs_assigns(params))
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Jobs")
  end

  defp get_jobs_assigns(params) do
    case BackgroundJobs.paginate_jobs(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
