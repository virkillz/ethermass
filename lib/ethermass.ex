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


  @spec refresh_metadata ::
          {:error, HTTPoison.Error.t()}
          | {:ok,
             %{
               :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
               optional(:body) => any,
               optional(:headers) => list,
               optional(:id) => reference,
               optional(:request) => HTTPoison.Request.t(),
               optional(:request_url) => any,
               optional(:status_code) => integer
             }}
  def refresh_metadata() do
    header = [
      {"accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"},
      {"User-agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36"},
      {"referrer", "https://api.opensea.io/api/v1/assets"},
      {"authority", "api.opensea.io"},
      {"cookie", "_gcl_au=1.1.1259710186.1641227868; amp_d28823=QK0DF49EgSw0L1fqdITwgW...1fok0bkok.1fok0c4kf.2.2.4; _ga_QN8V4MT4GF=GS1.1.1643284105.1.1.1643284204.0; _gid=GA1.2.1886916850.1643768440; _ga_9VSBF2K4BX=GS1.1.1643803304.21.1.1643806942.0; _ga=GA1.2.1872919539.1641227868; amp_ddd6ec=vKBvSWjXTP-wF5Cpv3Mjbi...1fqt4vo0h.1fqt8f808.fn.ec.u3; __cf_bm=0qWD9ksZW3HmQFWFLRpypLGPGRUypVBW1znG06Y1ysg-1643807761-0-AYEBnrLwzCLV+8DVQleDs4X3atcfGy5ZJw7UxHKE0Y3w1JLzl0GAhqiEFdOjyuWH/MHeQ8Hy7uhXQxyf4pEKDbI="}]
    HTTPoison.get("https://api.opensea.io/api/v1/asset/0x000a682feeeffc5e56a58a3b015fb07665d8a979/1191/?force_update=true", header)
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
