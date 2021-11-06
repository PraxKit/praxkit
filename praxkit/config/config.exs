# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :praxkit,
  ecto_repos: [Praxkit.Repo],
  generators: [binary_id: true]

config :praxkit, Praxkit.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :praxkit,
  stripe_service: Stripe,
  require_subscription: true,
  app_name: "Praxkit",
  page_url: "praxkit.ch",
  company_name: "Kapp Technology GmbH",
  company_address: "Schützengasse 38c",
  company_zip: "2502",
  company_city: "Biel-Bienne",
  company_state: "Bern",
  company_country: "Schweiz",
  contact_name: "Andreas Kapp",
  contact_phone: "+41 44 586 88 25",
  contact_email: "hallo@praxkit.ch",
  from_email: "hallo@praxkit.ch"

# Configures the endpoint
config :praxkit, PraxkitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hq+LxWvAR2M0kw6KPS1zokIlpM8Lp2ksyPS0GLzsg8/RUOTRonFGQI4nNHjKsLDW",
  render_errors: [view: PraxkitWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Praxkit.PubSub,
  live_view: [signing_salt: "81Ch8jqw"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.26",
  default: [
    args: ~w(js/app.js vendor/fonts/InterWeb/inter.css --bundle --loader:.woff2=file --loader:.woff=file --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),

    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :praxkit, Praxkit.Mailer, adapter: Swoosh.Adapters.Local

# Used for usaing a local client like Mailcatcher
# Mailcatcher is great when testing the emails in IEX
# config :praxkit, Praxkit.Mailer,
#   adapter: Swoosh.Adapters.SMTP,
#   relay: "127.0.0.1",
#   port: 1025

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :stripity_stripe,
  api_key: System.get_env("STRIPE_SECRET"),
  public_key: System.get_env("STRIPE_PUBLIC"),
  webhook_signing_key: System.get_env("STRIPE_WEBHOOK_SIGNING_KEY")

config :praxkit, :pow,
  user: Praxkit.Accounts.User,
  repo: Praxkit.Repo,
  web_module: PraxkitWeb,
  routes_backend: PraxkitWeb.Pow.Routes,
  mailer_backend: PraxkitWeb.Pow.Mailer,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks

config :praxkit, Praxkit.Admins.Guardian,
  issuer: "praxkit",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "GUARDIAN_ADMIN_SECRET_PLACEHOLDER"

config :praxkit, Praxkit.Accounts.Guardian,
  issuer: "praxkit",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY") || "GUARDIAN_SECRET_PLACEHOLDER"

config :praxkit, Oban,
  repo: Praxkit.Repo,
  queues: [default: 10, mailers: 20, high: 50, low: 5],
  plugins: [
    {Oban.Plugins.Pruner, max_age: (3600 * 24)},
    {Oban.Plugins.Cron,
      crontab: [
       # {"0 2 * * *", Praxkit.Workers.DailyDigestWorker},
       {"@reboot", Praxkit.Workers.StripeSyncWorker}
     ]}
  ]

config :praxkit, :env, Mix.env()

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
