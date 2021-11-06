defmodule PraxkitWeb.SharedComponents do
  use Phoenix.Component

  def heading(assigns) do
    ~H"""
    <div class="flex items-center justify-between pb-4 mt-4 mb-12 border-b border-base-200">
      <h3 class="text-2xl font-bold sm:text-4xl">
        <%= render_block(@inner_block) %>
      </h3>
    </div>
    """
  end

  def card(assigns) do
    ~H"""
    <div class={"card bg-base-100 rounded shadow border border-base-200 #{assigns[:class]}"}>
      <div class="card-body">
        <%= render_block(@inner_block) %>
      </div>
    </div>
    """
  end

  def alert(assigns) do
    ~H"""
    <div class={"alert alert-#{assigns[:type] || "type"}"}>
      <%= render_block(@inner_block) %>
    </div>
    """
  end
end
