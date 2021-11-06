defmodule Saas.DataTable.TableHelpers do
  @moduledoc """
  Helpers for rendering data table tables.
  """
  import Phoenix.LiveView.Helpers

  import Phoenix.HTML

  @doc """
  Generates a sortable link for a table heading.
  Clicking on the link will trigger a sort on that field. Clicking again will
  reverse the sort.
  ## Example
      iex> params = %{"sort_field" => "name", "sort_direction" => "asc"}
      ...> table_link(params, "Name", :name) |> safe_to_string()
      "<a class=\\"active asc\\" href=\\"?sort_direction=desc&amp;sort_field=name\\">Name<span class=\\"caret\\"></span></a>"
  """
  def table_link(params, text, field) do
    direction = params["sort_direction"]

    if params["sort_field"] == to_string(field) do
      opts = [
        sort_field: field,
        sort_direction: reverse(direction)
      ]

      live_patch to: "?" <> querystring(params, opts), class: "link flex items-center" do
        raw(~s{#{text}#{caret(reverse(direction))}})
      end
    else
      opts = [
        sort_field: field,
        sort_direction: "desc"
      ]

      live_patch to: "?" <> querystring(params, opts), class: "link flex items-center" do
        raw(~s{#{text}})
      end
    end
  end

  @doc """
  Prettifies and associated struct for display.
  Displays the model's name or "None", rather than the struct's ID.
  ## Examples
      iex> table_assoc_display_name(%{category_id: 1}, :category_id, [{"Articles", 1}])
      "Articles"
      iex> table_assoc_display_name(%{category_id: nil}, :category_id, [{"Articles", 1}])
      "None"
  """
  def table_assoc_display_name(struct, field, options) do
    case Enum.find(options, fn {_name, id} -> Map.get(struct, field) == id end) do
      {name, _id} -> name
      _other -> "None"
    end
  end

  @doc false
  def querystring(params, opts \\ %{}) do
    params = params |> Plug.Conn.Query.encode() |> URI.decode_query()

    opts = %{
      "page" => opts[:page],
      "sort_field" => opts[:sort_field] || params["sort_field"] || nil,
      "sort_direction" => opts[:sort_direction] || params["sort_direction"] || nil
    }

    params
    |> Map.merge(opts)
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
    |> URI.encode_query()
  end

  defp reverse("desc"), do: "asc"
  defp reverse("asc"), do: "desc"
  defp reverse(_), do: "desc"

  defp caret("asc") do
    """
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="w-3 h-3 ml-1" viewBox="0 0 16 16">
      <path d="M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z"/>
    </svg>
    """
  end

  defp caret(_) do
    """
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="w-3 h-3 ml-1" viewBox="0 0 16 16">
      <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
    </svg>
    """
  end
end
