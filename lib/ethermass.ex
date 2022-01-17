defmodule Ethermass do
  @moduledoc """
  Ethermass keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def get_eth_balance(address) do
    case ETH.Query.get_balance(address) do
      {:ok, result} -> result
      _other -> "n/a"
    end
  end

  def test() do
    account = "0xf86613BCf16C855446409F7F40a1ad9D9AB70A49"
    priv = "d34e3af448da5d482166ad413d6978cccdf4a245b8bff8804ab1c4f98c287067"

    File.read!("uni_abi.json") |> Jason.decode! |> ABI.parse_specification


  end

  def get_transaction_detail(hash) do
    Ethereumex.HttpClient.eth_get_transaction_by_hash(hash)
  end

  def get_explorer_link(address) do
    case Application.get_env(:ethereumex, :network) do
      "mainnet" -> "https://etherscan.io/address/#{address}"
      "rinkeby" -> "https://rinkeby.etherscan.io/address/#{address}"
      "ropsten" -> "https://ropsten.etherscan.io/address/#{address}"
      _ -> "-"
    end
  end

  def get_transaction_status(hash) do
    case Ethereumex.HttpClient.eth_get_transaction_receipt(hash) do
      {:ok, result} ->
        case result["status"] do
          "0x1" -> "success"
          "0x0" -> "failed"
          _other -> "undefined"
        end
      {:error, reason} ->
        IO.inspect(reason)
        "unknown"
    end
  end


end
