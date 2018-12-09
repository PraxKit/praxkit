defmodule Praxkit.Repo do
  use Ecto.Repo,
    otp_app: :praxkit,
    adapter: Ecto.Adapters.Postgres
end
