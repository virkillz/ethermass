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

  def get_network() do
    Application.get_env(:ethereumex, :network)
  end

  def get_transaction_detail(hash) do
    Ethereumex.HttpClient.eth_get_transaction_by_hash(hash)
  end

  def get_explorer_link(address, part \\ "address") do

    case Application.get_env(:ethereumex, :network) do
      "mainnet" -> "https://etherscan.io/#{part}/#{address}"
      "rinkeby" -> "https://rinkeby.etherscan.io/#{part}/#{address}"
      "ropsten" -> "https://ropsten.etherscan.io/#{part}/#{address}"
      _ -> "-"
    end
  end

  def private_key_to_address(private_key) do
    try do

    trimmed_priv_key =
      if String.starts_with?(private_key, "0x"), do: String.trim_leading(private_key, "0x"), else: private_key

      {:ok, ETH.Wallet.create(trimmed_priv_key)}
    rescue
      _ -> {:error, "Private key in wrong format. "}
    end

  end

  def random() do
    data =
    [
    %{
      name: "KKB",
      funder_count: 1,
      wallet: 50,
      nft: 200
    },
    %{
      name: "IOG",
      funder_count: 2,
      wallet: 100,
      nft: 400
    },
    %{
      name: "RGN",
      funder_count: 4,
      wallet: 200,
      nft: 800
    },
    %{
      name: "EBIT",
      funder_count: 2,
      wallet: 75,
      nft: 300
    },
    %{
      name: "BBG",
      funder_count: 2,
      wallet: 100,
      nft: 400
    },
    %{
      name: "RSBBI",
      funder_count: 2,
      wallet: 100,
      nft: 400
    },
    %{
      name: "PT",
      funder_count: 10,
      wallet: 375,
      nft: 1500
    }]

      Enum.map(data, fn x ->

        %{
          name: x.name,
          nft_per_wallet: x.nft/x.wallet
        }

      end)
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
