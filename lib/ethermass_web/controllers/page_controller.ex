defmodule EthermassWeb.PageController do
  use EthermassWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def test(conn, _params) do
    render(conn, "test.html")
  end
end
