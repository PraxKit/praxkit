defmodule Saas.DataTable do
  defmacro __using__(_opts) do
    quote do
      import Phoenix.LiveView.Helpers
      import Saas.DataTable.TableHelpers
      import Saas.DataTable.PaginationHelpers

      import Saas.FilterHelpers

      def pagination(assigns) do
        live_component Saas.DataTable.PaginationComponent, assigns
      end
    end
  end
end
