defmodule PraxkitWeb.PageController do
  use PraxkitWeb, :controller

  @app_name Application.get_env(:praxkit, :app_name)
  @company_name Application.get_env(:praxkit, :company_name)

  def privacy(conn, _params) do
    render(conn, "privacy.html", app_name: @app_name, company_name: @company_name)
  end

  def terms(conn, _params) do
    render(conn, "terms.html", app_name: @app_name, company_name: @company_name)
  end
end
