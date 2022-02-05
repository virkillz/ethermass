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

    mm_summary =  Ethermass.Monitoring.list_market_maker_summary()

    render(conn, "index.html", mm_summary: mm_summary, gas_cost: gas_cost, owned_nft: owned_nft, gas_price_protocol: gas_price_protocol)
  end

  def all_nft(conn, _) do

    range = 1..8000


    render(conn, "test.html", range: range)
  end

  def mass_funding_index(conn, _params) do
    render(conn, "mass_funding_index.html")
  end

  def test(conn, _params) do
    render(conn, "test.html")
  end
end
