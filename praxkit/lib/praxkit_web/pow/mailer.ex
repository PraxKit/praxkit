defmodule PraxkitWeb.Pow.Mailer do
  use Pow.Phoenix.Mailer

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    Praxkit.Emails.pow_email(%{user: user, subject: subject, text: text, html: html})
  end

  @impl true
  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.

    Praxkit.Mailer.deliver_later(email)
  end
end
