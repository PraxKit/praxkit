defmodule Saas.DataTable.PaginationComponent do
  use PraxkitWeb, :live_component

  import Saas.DataTable.TableHelpers
  import Saas.DataTable.PaginationHelpers

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    distance = Map.get(assigns, :distance, 5)

    ~L"""
    <div id="<%= assigns[:id] || "pagination" %>" class="flex justify-center my-2">
      <%= if @total_pages > 1 do %>
        <div class="btn-group">
          <%= prev_link(@params, @page_number) %>
          <%= for num <- start_page(@page_number, distance)..end_page(@page_number, @total_pages, distance) do %>
            <%= live_patch num, to: "?" <> querystring(@params, page: num), class: "btn #{if @page_number == num, do: "btn-active", else: ""}" %>
          <% end %>
          <%= next_link(@params, @page_number, @total_pages) %>
        </div>
      <% end %>
    </div>
    """
  end
end
