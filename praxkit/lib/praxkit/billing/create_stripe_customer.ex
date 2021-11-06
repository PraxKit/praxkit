defmodule Praxkit.Billing.CreateStripeCustomer do
  @moduledoc """
  """
  use GenServer

  import Ecto.Query, warn: false
  alias Praxkit.Repo
  alias Praxkit.Billing.Customer

  @stripe_service Application.get_env(:praxkit, :stripe_service)

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(state) do
    Praxkit.Accounts.subscribe_on_account_created()
    {:ok, state}
  end

  def handle_info(%{account: account, email: email}, state) do
    create_customer_in_stripe(%{account: account, email: email})
    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  def create_customer_in_stripe(%{account: account, email: email}) do
    {:ok, %{id: stripe_id}} = @stripe_service.Customer.create(%{email: email})

    {:ok, billing_customer} =
      account
      |> Ecto.build_assoc(:billing_customer)
      |> Customer.changeset(%{stripe_id: stripe_id})
      |> Repo.insert()

    notify_subscribers(billing_customer)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Praxkit.PubSub, "stripe_customer_created")
  end

  def notify_subscribers(customer) do
    Phoenix.PubSub.broadcast(Praxkit.PubSub, "stripe_customer_created", {:customer, customer})
  end

  defmodule Stub do
    use GenServer
    def start_link(_), do: GenServer.start_link(__MODULE__, nil)
    def init(state), do: {:ok, state}
  end
end
