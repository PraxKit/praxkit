defmodule PraxkitWeb.Admin.InvoiceLiveTest do
  use PraxkitWeb.ConnCase

  import Phoenix.LiveViewTest
  import Praxkit.BillingFixtures

  defp create_invoice(_) do
    invoice = invoice_fixture(%{stripe_id: unique_stripe_id()})
    %{invoice: invoice}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_invoice]

    test "lists all invoices", %{conn: conn, invoice: invoice} do
      {:ok, _index_live, html} = live(conn, Routes.admin_invoice_index_path(conn, :index))

      assert html =~ "Listing Invoices"
      assert html =~ invoice.stripe_id
    end
  end
end
