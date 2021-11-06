# PraxKit

## License

See [License](../License.md)

## Docs

  * [Introdction](docs/introduction.md)
  * [Technology](docs/technology.md)
  * [Installation](docs/installation.md)
  * [Initial Setup](docs/initial_setup.md)
  * [CSS and Styling](docs/styling.md)
  * [Multi Tenancy](docs/multitenancy.md)
  * [Tests](docs/tests.md)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Changes

*  https://hub.docker.com/r/bitwalker/alpine-elixir-phoenix
*  dev.exs:   hostname: "db"
*  ENV PORT=5000 MIX_ENV=dev insted of prod

