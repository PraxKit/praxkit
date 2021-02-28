# Praxkit

[![](https://img.shields.io/badge/license-Apache_2.0_plus_Common_Clause-blue.svg)]()

A software for managing your counseling business.
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Install database schemas with `mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


## `run` vs `exec`

When executing a command with `docker-compose` it can be run with either `run` or `exec`. 

From the docs:
- The docker `run` command first creates a writeable container layer over the specified image, and then `starts` it using the specified command
  - If using `run`, adding the `--rm` flag will automatically remove the container when the command is finished
- The docker `exec` command runs a new command in a running container

References:
https://docs.docker.com/engine/reference/commandline/run/
https://docs.docker.com/engine/reference/commandline/exec/

----
## Debugging
With the project running on Docker, the standard `iex -S mix` will not work to spin up an iEX console. An updated command, that works with Docker is:

`docker-compose exec app iex -S mix`

This command will maintain history from one iEX shell to another:

`docker-compose exec app iex --erl "-kernel shell_history enabled" -S mix`

    docker-compose exec app /bin/bash
    docker-compose exec app mix ecto.setup
    docker-compose exec app mix deps.get
    docker-compose exec app mix credo
## License

Apache 2.0 with Commons Clause - see [LICENSE](LICENSE)