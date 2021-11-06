defmodule PraxkitWeb.PowResetPassword.MailerView do
  use PraxkitWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end
