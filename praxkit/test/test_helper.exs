ExUnit.configure(exclude: :feature)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Praxkit.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, PraxkitWeb.Endpoint.url)
