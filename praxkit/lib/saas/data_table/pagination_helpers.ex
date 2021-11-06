defmodule Saas.DataTable.PaginationHelpers do
  @moduledoc """
  Helpers for rendering data table pagination.
  """

  import Phoenix.LiveView.Helpers
  import Saas.DataTable.TableHelpers

  @doc """
  Generates a "Prev" link to the previous page of results.
  The link is only returned if there is a previous page.
  ## Examples
      iex> prev_link(%Plug.Conn{params: %{}}, 2) |> safe_to_string()
      "<a href=\\"?page=1\\">&lt; Prev</a>"
  If the current page is 1, returns `nil`:
      iex> prev_link(%Plug.Conn{params: %{}}, 1)
      nil
  """
  def prev_link(conn, current_page) do
    if current_page != 1 do
      live_patch "Prev", to: "?" <> querystring(conn, page: current_page - 1), class: "btn"
    else
      live_patch "Prev", to: "#", class: "btn btn-disabled"
    end
  end

  @doc """
  Generates a "Next" link to the next page of results.
  The link is only returned if there is another page.
  ## Examples
      iex> next_link(%Plug.Conn{params: %{}}, 1, 2) |> safe_to_string()
      "<a href=\\"?page=2\\">Next &gt;</a>"
      iex> next_link(%Plug.Conn{}, 2, 2)
      nil
  """
  def next_link(conn, current_page, num_pages) do
    if current_page != num_pages do
      live_patch "Next", to: "?" <> querystring(conn, page: current_page + 1), class: "btn"
    else
      live_patch "Next", to: "#", class: "btn btn-disabled"
    end
  end

  def start_page(current_page, distance)
       when current_page - distance <= 0 do
    1
  end

  def start_page(current_page, distance) do
    current_page - distance
  end

  def end_page(current_page, 0, _distance) do
    current_page
  end

  def end_page(current_page, total, distance)
       when current_page <= distance and distance * 2 <= total do
    distance * 2
  end

  def end_page(current_page, total, distance) when current_page + distance >= total do
    total
  end

  def end_page(current_page, _total, distance) do
    current_page + distance - 1
  end
end
