defmodule Praxkit.Mailer do
  use Swoosh.Mailer, otp_app: :praxkit

  def deliver_later(email) do
    deliver(email)
  end
end
