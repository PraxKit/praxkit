defmodule Praxkit.Billing.SynchronizeProductsTest do
  use Praxkit.DataCase

  alias Praxkit.Billing.Products
  alias Praxkit.Billing.SynchronizeProducts

  describe "run" do
    test "run/0 syncs products from stripe and creates them in billing_products" do
      assert Products.list_products() == []

      SynchronizeProducts.run()
      assert [%Praxkit.Billing.Product{}] = Products.list_products()
    end

    test "run/0 deletes products that exists in local database but does not exists in stripe" do
      {:ok, product} =
        Products.create_product(%{
          name: "Dont exists",
          stripe_id: "prod_abc123def456"
        })

      assert Products.list_products() == [product]

      SynchronizeProducts.run()
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end
  end
end
