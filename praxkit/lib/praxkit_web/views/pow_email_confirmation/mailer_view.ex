defmodule PraxkitWeb.PowEmailConfirmation.MailerView do
  use PraxkitWeb, :mailer_view

  def subject(:email_confirmation, _assigns), do: "Confirm your email address"
end
