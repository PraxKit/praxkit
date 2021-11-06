defmodule PraxkitWeb.App.HomeLive do
  use PraxkitWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
