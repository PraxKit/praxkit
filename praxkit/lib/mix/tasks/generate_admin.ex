defmodule Mix.Tasks.GenerateAdmin do
  @shortdoc "Genrate an admin account and randomize password"

  @moduledoc """
  # run: mix generate_admin email@example.com
  """
  use Mix.Task

  alias Praxkit.Admins

  @doc false
  def run([email]) do
    Application.ensure_all_started(:praxkit)

    password = generate_password()

    case Admins.create_admin(%{email: email, password: password, password_confirmation: password}) do
      {:ok, _admin} ->
        Mix.shell().info """
        An admin was created with the
          email: #{email}
          password: #{password}
        """

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset.errors
    end
  end

  defp generate_password() do
    :crypto.strong_rand_bytes(12)
    |> Base.url_encode64()
    |> binary_part(0, 12)
  end
end
