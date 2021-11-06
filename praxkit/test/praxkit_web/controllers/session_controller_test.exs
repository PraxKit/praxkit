defmodule PraxkitWeb.SessionControllerTest do
  use PraxkitWeb.ConnCase, async: true

  import Praxkit.AccountsFixtures

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Log in</h5>"
      assert response =~ "Forgot your password?</a>"
      assert response =~ "Sign in</button>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_with_account_fixture())
        |> get(Routes.user_session_path(conn, :new))

      assert redirected_to(conn) == "/"
    end
  end

  describe "create user session" do
    test "with valid data it logs in the user", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          user: %{
            email: user.email,
            password: valid_user_password()
          }
        })

      assert redirected_to(conn) == "/app"
    end

    test "render errors for invalid data", %{conn: conn} do
      user = user_fixture()

      conn =
        post(conn, Routes.user_session_path(conn, :create), %{
          user: %{
            email: user.email,
            password: "wrongpass",
            password_confirmation: "wrongpass"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "Log in</h5>"
      assert response =~ "Forgot your password?</a>"
      assert response =~ "Sign in</button>"
    end
  end

  describe "delete user session" do
    test "deletes a logged in user", %{conn: conn} do
      conn =
        conn
        |> log_in_user(user_fixture())
        |> delete(Routes.user_session_path(conn, :delete))

      assert redirected_to(conn) == "/app/sign_in"

      conn = get(conn, "/app")
      assert redirected_to(conn) =~ "/app/session/new"
    end
  end
end
