defmodule EthermassWeb.PageController do
  use EthermassWeb, :controller

  def index(conn, _params) do

    gas_cost =
    case Etherscan.get_gas() do
      {:ok, result} -> result
      _ -> %{}
    end

    render(conn, "index.html", gas_cost: gas_cost)
  end

  def mass_funding_index(conn, _params) do
    render(conn, "mass_funding_index.html")
  end

  def test(conn, _params) do
    render(conn, "test.html")
  end
end
