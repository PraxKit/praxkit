defmodule PraxkitWeb.PageController do
  use PraxkitWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
