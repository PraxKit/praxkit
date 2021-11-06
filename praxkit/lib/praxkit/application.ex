defmodule Praxkit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    create_stripe_customer_service =
      if Application.get_env(:praxkit, :env) == :test,
        do: Praxkit.Billing.CreateStripeCustomer.Stub,
        else: Praxkit.Billing.CreateStripeCustomer

    webhook_processor_service =
      if Application.get_env(:praxkit, :env) == :test,
        do: Praxkit.Billing.WebhookProcessor.Stub,
        else: Praxkit.Billing.WebhookProcessor

    children = [
      # Start the Ecto repository
      Praxkit.Repo,
      # Start the Telemetry supervisor
      PraxkitWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Praxkit.PubSub},
      # Start the Endpoint (http/https)
      PraxkitWeb.Endpoint,
      # Start a worker by calling: Praxkit.Worker.start_link(arg)
      # {Praxkit.Worker, arg}
      {Oban, oban_config()},

      create_stripe_customer_service,
      webhook_processor_service
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Praxkit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PraxkitWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:praxkit, Oban)
  end
end
