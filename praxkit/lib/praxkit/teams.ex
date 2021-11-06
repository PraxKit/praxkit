defmodule Praxkit.Teams do
  @moduledoc """
  Module is responsible for team related functions.
  """

  alias Praxkit.Emails
  alias Praxkit.Mailer
  alias PraxkitWeb.Router.Helpers, as: Routes

  @doc """
  Invite a user to specific account. Sends an email with a magic link to the
  provided email. The user that clicks on the link will be presented with a
  signup form in PraxkitWeb.InvitationController
  """
  def invite_member(%{account_id: account_id, email: email}) do
    token = Phoenix.Token.sign(PraxkitWeb.Endpoint, "invite_member", account_id)
    url = Routes.invitation_url(PraxkitWeb.Endpoint, :new, token)

    Emails.invite_user_email(%{email: email, url: url})
    |> Mailer.deliver_later()
  end
end
