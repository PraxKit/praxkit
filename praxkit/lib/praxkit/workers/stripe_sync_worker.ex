defmodule Praxkit.Workers.StripeSyncWorker do
  @moduledoc """
  Syncs products and plans with Stripe
  """
  use Oban.Worker

  alias Praxkit.Billing.SynchronizeProducts
  alias Praxkit.Billing.SynchronizePlans

  @impl Oban.Worker
  def perform(_job) do
    case Application.fetch_env(:stripity_stripe, :api_key) do
      {:ok, _ } ->
        SynchronizeProducts.run()
        SynchronizePlans.run()
      _ ->
        nil
    end

    :ok
  end
end
