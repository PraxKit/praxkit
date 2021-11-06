defmodule Praxkit.Accounts.User do
  use Praxkit.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword, PowEmailConfirmation]

  import Ecto.Changeset

  @derive {Inspect, except: [:password]}
  schema "users" do
    pow_user_fields()

    field :name, :string
    field :channel_name, :string

    belongs_to :account, Praxkit.Accounts.Account
    has_many :notifications, Praxkit.InAppNotifications.Notification

    timestamps()
  end

  @doc false
  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> set_channel_name(user_or_changeset)
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password()
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    Pow.Ecto.Schema.Changeset.current_password_changeset(changeset, %{current_password: password}, [])
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 80)
  end

  # Channel name should only be set once and be unique for each user. Its used to send
  # channel notifications and pub sub messages to a specific user
  defp set_channel_name(changeset, %{channel_name: "" <> _}), do: changeset
  defp set_channel_name(changeset, _struct) do
    channel_name = create_channel_name()
    put_change(changeset, :channel_name, channel_name)
  end

  defp create_channel_name() do
    :crypto.strong_rand_bytes(15)
    |> Base.url_encode64
    |> binary_part(0, 15)
  end
end
