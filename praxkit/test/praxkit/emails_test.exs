defmodule Praxkit.EmailsTest do
  use Praxkit.DataCase, async: true

  alias Praxkit.Emails

  @from Application.get_env(:praxkit, :from_email)

  test "welcome email" do
    user = %{name: "John Doe", email: "john.doe@example.com"}

    email = Emails.welcome_email(user)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", @from}
    assert email.html_body =~ "Welcome"
    assert email.text_body =~ "Welcome"
  end

  test "pow email" do
    user = %Praxkit.Accounts.User{email: "john.doe@example.com"}
    message = %{user: user, subject: "Some subject", text: "Some text", html: "<p>Some html</p>"}

    email = Emails.pow_email(message)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", @from}
    assert email.subject == "Some subject"
    assert email.html_body =~ "Some html</p>"
  end

  test "admin login link email" do
    message = %{url: ~s(#somelinkwithtoken), email: "john.doe@example.com"}

    email = Emails.admin_login_link(message)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", @from}
    assert email.html_body =~ "href=\"#somelinkwithtoken\""
  end

  test "invite user email" do
    message = %{url: ~s(#somelinkwithtoken), email: "john.doe@example.com"}

    email = Emails.invite_user_email(message)

    assert email.to == [{"", "john.doe@example.com"}]
    assert email.from == {"", @from}
    assert email.html_body =~ "href=\"#somelinkwithtoken\""
  end
end
