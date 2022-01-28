defmodule BaliverseContract do

# @contract "0xf4d6F145dCEACa8c49f1b267f29fFEd8dE6B11f2"
# @contract "0x044691575fa502c099c8b61b1e79b225bec89b1f"
# @contract "0x0917e55b6eec945d71bcc3bab61451a2cf289fcd"
@contract "0xA7c90B3fBF944D0c366470Af796E810F9c177230"


def all_functions() do
  abi = EthContract.parse_abi("uni_abi.json")
  Enum.filter(abi, fn {_k,v} -> v["type"] == "function" end) |> Enum.map(fn {k, _v} -> k end)
end

def parse() do
  File.read!("uni_abi.json")
  |> Jason.decode!
  |> ABI.parse_specification

end

def function_detail(name) do
  abi = EthContract.parse_abi("uni_abi.json")
  Enum.filter(abi, fn {_k,v} -> v["type"] == "function" end) |> Enum.filter(fn {k,_v} -> k == name end)
end

def function_types() do
  "uni_abi.json"
  |> EthContract.parse_abi()
  |> Enum.filter(fn {_k,v} -> v["type"] == "function" end)
  |> Enum.filter(fn {_k, v} -> v["stateMutability"] == "view" end)
  |> Enum.map(fn {k, _v} -> k end)
end


# -----------------

def call(name, args \\ []) do

  with {:ok, function_signature} <- validate_function_signature(name),
        {:ok, args} <- validate_args(function_signature, args)
  do
    data =
      ABI.encode(function_signature, args, :input)
      |> Base.encode16(case: :lower)

    case Ethereumex.HttpClient.eth_call(%{data: "0x" <> data, to: @contract }) do
        {:ok, "0x" <> result} ->

          function_signature
          |> ABI.decode(result |> Base.decode16!(case: :lower), :output)

          error -> error
    end
  else
    error -> error
  end

end

def validate_function_signature(name) do

result =
  "uni_abi.json"
  |> EthContract.parse_abi()
  |> Enum.filter(fn {k,_v} -> k == name end)
  |> List.last()

if is_nil(result) do
  {:error, "Invalid function name for this contract."}
else
  {_, function_detail} = result
  if function_detail["type"] != "function" do
    {:error, "is not a function"}
  else
    if function_detail["stateMutability"] != "view" do
      {:error, "This is not a view function"}
    else

      {:ok,
      File.read!("uni_abi.json")
      |> Jason.decode!
      |> ABI.parse_specification
      |> Enum.find(&(&1.function == name))}
    end
  end
end

end
def validate_args(function_signature, args) do
  if Enum.count(function_signature.types) == Enum.count(args) do
    {:ok, args}
  else
    {:error, "Arguments should consist of #{Enum.count(function_signature.types)}"}
  end
end



def name() do
  data =
  ABI.encode("name()", [])
  |> Base.encode16(case: :lower)

  case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: @contract }) do
    {:ok, "0x" <> result} ->
      ABI.decode("name(string)", result |> Base.decode16!(case: :lower)) |> List.last

      error -> error
  end
end

def only_whitelisted() do
  data =
  ABI.encode("onlyWhitelisted()", [])
  |> Base.encode16(case: :lower)

  case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: @contract }) do
    {:ok, "0x" <> result} ->
      ABI.decode("onlyWhitelisted(bool)", result |> Base.decode16!(case: :lower)) |> List.last

      error -> error
  end
end

def is_whitelisted(address) do
  case EthContract.Util.address_to_bytes(address) do
    {:ok, address} ->
      case call("whitelistedAddresses", [address]) do
        {:error, error} -> {:error, error}
        [result] -> result
      end
    error -> error
  end
end

def paused() do
  data =
  ABI.encode("paused()", [])
  |> Base.encode16(case: :lower)

  case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: @contract }) do
    {:ok, "0x" <> result} ->
      ABI.decode("paused(bool)", result |> Base.decode16!(case: :lower)) |> List.last

      error -> error
  end
end

def max_supply() do
  data =
  ABI.encode("maxSupply()", [])
  |> Base.encode16(case: :lower)

  case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: @contract }) do
    {:ok, "0x" <> result} ->
      ABI.decode("maxSupply(uint256)", result |> Base.decode16!(case: :lower)) |> List.last

      error -> error
  end
end

def owner() do
  data =
  ABI.encode("owner()", [])
  |> Base.encode16(case: :lower)

  case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: @contract }) do
    {:ok, "0x" <> result} ->
      ABI.decode("owner(address)", result |> Base.decode16!(case: :lower)) |> List.last

      error -> error
  end
end

def balance_of(address) do
  balance_of(address, @contract)
end

@spec balance_of(binary, any) ::
        {:error, atom | binary | map} | {:ok, any} | %{optional(<<_::48, _::_*8>>) => any}
def balance_of(address, contract) do
  case EthContract.Util.address_to_bytes(address) do
    {:ok, address} ->
      data =
        ABI.encode("balanceOf(address)", [address])
        |> Base.encode16(case: :lower)

        case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: contract }) do
          {:ok, "0x" <> result} ->
            result = ABI.decode("balanceOf(uint256)", result |> Base.decode16!(case: :lower)) |> List.last

            {:ok, result}

            error -> error
        end
    error -> error
  end
end

def total_supply() do
  data =
  ABI.encode("totalSupply()", [])
  |> Base.encode16(case: :lower)

  case Ethereumex.HttpClient.eth_call(%{ data: "0x" <> data, to: @contract }) do
    {:ok, "0x" <> result} ->
      ABI.decode("totalSupply(uint256)", result |> Base.decode16!(case: :lower)) |> List.last

      error -> error
  end
end


def mint() do
  data =
    ABI.encode("mint(uint256)", [1])
    |> Base.encode16(case: :lower)

  private_key = "6ABA74463967E0BDE1898D70CF00668A17EF15D987EFF4E587F6B1CAB8CF5262"

  params = %{to: @contract, gas_limit: 10_000_000 |> to_hex, gas_price: 100_500_000_000 |> to_hex, from: "0xC9C35A8FD6C117BE5619B6E28AD8F50B921E9B10", value: 50_000_000_000_000_000, data: "0x" <> data}

  ETH.send_transaction(params, private_key)
end


def whitelist(address, amount) do
  case EthContract.Util.address_to_bytes(address) do
    {:ok, address} ->
      data =
        ABI.encode("whitelistUsers(address, uint256)", [address, amount])
        |> Base.encode16(case: :lower)

    contract = "0xA7c90B3fBF944D0c366470Af796E810F9c177230"

    private_key = "78bfc840e70f4039a62bf9c7bf06d2a9cc2cada6c6cc131d882f2c168d0824f0"

    params = %{to: contract, gas_limit: 10_000_000 |> to_hex, gas_price: 2000000000 |> to_hex, from: "0xBac12164b5e7B2b5f8b66021477c84Ab77250B70", value: 0, data: "0x" <> data}

    ETH.send_transaction(params, private_key)

    error -> error
  end
end

def to_hex(something) do
  "0x" <> Hexate.encode(something)
end



end
