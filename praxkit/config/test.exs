use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :praxkit, Praxkit.Repo,
  username: "postgres",
  password: "postgres",
  database: "praxkit_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  queue_target: 5000,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :praxkit, PraxkitWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fsPmhmYFTQ1VLY28VpofzOHOqKcbLbGa7BzWeF2yLdGAlt61dqZ0yoa7XVfPioVR",
  server: true

# In test we don't send emails.
config :praxkit, Praxkit.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :praxkit,
  stripe_service: MockStripe,
  require_subscription: false

# Recommended to lower the iterations count in
# your test environment to speed up your tests
config :pow, Pow.Ecto.Schema.Password, iterations: 1
config :bcrypt_elixir, :log_rounds, 1

config :praxkit, Praxkit.Admins.Guardian,
  issuer: "praxkit",
  secret_key: "1RCGH+jnTgJNVrkKQMrebh6AOkYRLrpThEPM37fEIYHXtJCEvwAjdQwbRLv8GPWJ"

config :praxkit, Praxkit.Accounts.Guardian,
  issuer: "praxkit",
  secret_key: "hS5jzOOsnvcmGvhz6B1B+FfbtfKY2wvTxYSLC6CcC8WY2pNLsx59nEPwWOnwIAHL"

config :praxkit, Oban, queues: false, plugins: false
config :wallaby, otp_app: :praxkit
config :praxkit, :sandbox, Ecto.Adapters.SQL.Sandbox
