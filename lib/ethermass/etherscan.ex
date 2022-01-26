defmodule Etherscan do

  @api_key "KD221BAQXZ69IXSQ6WDJG3YZJ5XVY5JDG7"

def get_balances(addresses) do

  addr = Enum.join(addresses, ",")

  url = get_base_url() <> "api?module=account&action=balancemulti&address=#{addr}&tag=latest&apikey=#{@api_key}"
  headers = [{"User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML like Gecko) Chrome/50.0.2661.102 Safari/537.36"}]

  case HTTPoison.get(url, headers) do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> Jason.decode(body)
    error -> error
  end
end

def get_gas_compact() do
  case get_gas() do
    {:ok, result} -> [{"Instant - #{result.instant} gwei", result.instant}, {"Fast - #{result.fast} gwei", result.fast}, {"Normal - #{result.normal} gwei", result.normal}, {"Slow - #{result.slow} gwei", result.slow}]
    _ -> []
  end
end

def get_gas_raw() do
  url = "https://ethgas.watch/api/gas"

  case HTTPoison.get(url) do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> Jason.decode(body)
    error -> error
  end
end

def get_gas() do
  case get_gas_raw() do
    {:ok, result} ->
      {:ok, %{
        fast: result["fast"]["gwei"],
        normal: result["normal"]["gwei"],
        instant: result["instant"]["gwei"],
        slow: result["slow"]["gwei"]
      }}
    error -> error
  end
end

def get_base_url() do
  network = Application.get_env(:ethereumex, :network)

  case network do
    "ropsten" -> "https://api-ropsten.etherscan.io/"
    "mainnet" -> "https://api.etherscan.io/"
    "rinkeby" -> "https://api-rinkeby.etherscan.io/"
  end
end

end
