defmodule PraxkitWeb.Pow.SkipAccountIdCheck do
  # This is used for some requests like Pow create session
  # Its used in a custom Plug `SkipAccountIdCheck` and
  # in a `refute_current_user` pipeline

  def init(options), do: options

  def call(conn, _opts) do
    Praxkit.Repo.put_skip_account_id(true)
    conn
  end
end
