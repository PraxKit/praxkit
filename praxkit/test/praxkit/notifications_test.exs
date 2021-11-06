defmodule Praxkit.NotificationsTest do
  use Praxkit.DataCase, async: true

  import Praxkit.AccountsFixtures

  alias Praxkit.Notifications

  test "signup" do
    user = user_fixture()

    assert Notifications.signup(user) == :ok

    assert [%Praxkit.InAppNotifications.Notification{}] =
             Praxkit.InAppNotifications.list_notifications(user)
  end
end
