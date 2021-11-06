defmodule Praxkit.Billing.WebhookProcessorTest do
  use Praxkit.DataCase

  @stripe_service Application.get_env(:praxkit, :stripe_service)

  alias Praxkit.Billing.WebhookProcessor
  alias PraxkitWeb.StripeWebhookController

  def event_fixture(attrs \\ %{}) do
    @stripe_service.Event.generate(attrs)
  end

  describe "listen for and processing a stripe event" do
    test "processes incoming events after broadcasing it" do
      start_supervised(WebhookProcessor, [])
      WebhookProcessor.subscribe()

      event = event_fixture()
      StripeWebhookController.notify_subscribers(event)

      assert_receive {:event, _}
    end
  end
end
