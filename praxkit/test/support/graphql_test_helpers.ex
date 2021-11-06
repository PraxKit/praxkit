defmodule Praxkit.GraphqlTestHelpers do
  import Praxkit.AccountsFixtures

  def user_with_valid_jwt(%{conn: conn}) do
    user = user_fixture()

    {:ok, jwt, _full_claims} = Praxkit.Accounts.Guardian.encode_and_sign(user)
    {:ok, conn: Plug.Conn.put_req_header(conn, "authorization", "Bearer #{jwt}"), jwt: jwt, user: user}
  end

  def user_with_invalid_jwt(%{conn: conn}) do
    user = user_fixture()

    {:ok, conn: conn, jwt: nil, user: user}
  end
  #
  # def with_product(_) do
  #   product = product_fixture()
  #   [product: product]
  # end
end
