defmodule Praxkit.TeamsTest do
  use Praxkit.DataCase, async: true

  import Swoosh.TestAssertions
  import Praxkit.AccountsFixtures

  alias Praxkit.Teams

  test "invite_member/1 sends the email with the decodable token" do
    email = "some@email.com"
    account = account_fixture()

    Teams.invite_member(%{account_id: account.id, email: email})

    assert_email_sent subject: "Invited to join"
  end
end
