defmodule Praxkit.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :name, :string
      add :email, :citext, null: false
      add :password_hash, :string, null: false
      add :email_confirmation_token, :string
      add :email_confirmed_at, :utc_datetime
      add :unconfirmed_email, :string

      add :account_id, references(:accounts, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:users, [:account_id])
    create unique_index(:users, [:email])
    create unique_index(:users, [:email_confirmation_token])
  end
end
