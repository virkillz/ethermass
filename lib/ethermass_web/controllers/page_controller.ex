defmodule EthermassWeb.PageController do
  use EthermassWeb, :controller

  def index(conn, _params) do

    owned_nft = Ethermass.Wallet.count_owned_nft()

    gas_cost =
      case Etherscan.get_gas() do
        {:ok, result} -> result
        _ -> %{}
      end

    gas_price_protocol =
      case ETH.Query.gas_price() do
        {:ok, wei} -> wei / 1000_000_000
        {:error, _} -> "n/a"
      end

    render(conn, "index.html", gas_cost: gas_cost, owned_nft: owned_nft, gas_price_protocol: gas_price_protocol)
  end

  def mass_funding_index(conn, _params) do
    render(conn, "mass_funding_index.html")
  end

  def test(conn, _params) do
    render(conn, "test.html")
  end
end
