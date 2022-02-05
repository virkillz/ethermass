defmodule Ethermass.Monitoring do
  @moduledoc """
  The Monitoring context.
  """

  import Ecto.Query, warn: false
  alias Ethermass.Repo

  alias Ethermass.Monitoring.OwnerList

  @doc """
  Returns the list of owner_list.

  ## Examples

      iex> list_owner_list()
      [%OwnerList{}, ...]

  """
  def list_owner_list do

    query = from i in OwnerList,
            order_by: i.token_id

    Repo.all(query)
  end

  @doc """
  Gets a single owner_list.

  Raises `Ecto.NoResultsError` if the Owner list does not exist.

  ## Examples

      iex> get_owner_list!(123)
      %OwnerList{}

      iex> get_owner_list!(456)
      ** (Ecto.NoResultsError)

  """
  def get_owner_list!(id), do: Repo.get!(OwnerList, id)

  @doc """
  Creates a owner_list.

  ## Examples

      iex> create_owner_list(%{field: value})
      {:ok, %OwnerList{}}

      iex> create_owner_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_owner_list(attrs \\ %{}) do
    %OwnerList{}
    |> OwnerList.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a owner_list.

  ## Examples

      iex> update_owner_list(owner_list, %{field: new_value})
      {:ok, %OwnerList{}}

      iex> update_owner_list(owner_list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_owner_list(%OwnerList{} = owner_list, attrs) do
    owner_list
    |> OwnerList.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a owner_list.

  ## Examples

      iex> delete_owner_list(owner_list)
      {:ok, %OwnerList{}}

      iex> delete_owner_list(owner_list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_owner_list(%OwnerList{} = owner_list) do
    Repo.delete(owner_list)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking owner_list changes.

  ## Examples

      iex> change_owner_list(owner_list)
      %Ecto.Changeset{data: %OwnerList{}}

  """
  def change_owner_list(%OwnerList{} = owner_list, attrs \\ %{}) do
    OwnerList.changeset(owner_list, attrs)
  end


  # Ethermass.Monitoring.download_latest_owner_list_csv()
  def download_latest_owner_list_csv() do


    table_data =
    list_owner_list()
    |> Enum.map(fn x ->


      [x.token_id, x.address, x.last_check |> NaiveDateTime.add(60 * 60 * 8, :second)]
    end)

    file = File.open!("owner_list.csv", [:write, :utf8])
    table_data |> CSV.encode |> Enum.each(&IO.write(file, &1))

  end

  # Ethermass.Monitoring.download_latest_market_maker_csv()
  def download_latest_market_maker_csv() do


    table_data =
    list_market_maker()
    |> Enum.map(fn x ->


      [x.address, x.group, x.nft_balance, x.eth_balance, x.last_check |> NaiveDateTime.add(60 * 60 * 8, :second)]
    end)

    file = File.open!("market_maker_updated.csv", [:write, :utf8])
    [["Address", "Group", "NFT Balance", "ETH Balance", "Last Update"] | table_data] |> CSV.encode |> Enum.each(&IO.write(file, &1))

  end


  # Ethermass.Monitoring.insert_nft_owner(1)
  def insert_nft_owner(id) do
    # range = 1..8000
    # Enum.each(range, fn x ->

    #   IO.inspect(x)

    :timer.sleep(300);

      case BaliverseContract.owner_of(id) do
        {:ok, address} ->

          attrs = %{
            "token_id" => id,
            "last_check" => NaiveDateTime.utc_now(),
            "address" => address
          }

          create_owner_list(attrs)
        {:error, _reason} -> IO.inspect("issue when updating ##{id}")
      end
  #   end)
  end





  alias Ethermass.Monitoring.MarketMaker


  # Ethermass.Monitoring.upload_all_market_maker()
  def upload_all_market_maker() do
    file_path = "priv/csvs/market_maker.csv"

    [_title | content] =
    File.stream!(file_path)
    |> CSV.decode!
    |> Enum.map(fn x -> x end)

    content
    |> Enum.map(fn [address, group] ->

      new_address = "0x" <> (address |> String.trim_leading("0x") |> String.upcase)

      %{
        "address" => new_address,
        "group" => group
      }
      |> create_market_maker()
    end)
    |> Enum.filter(fn {status, _value} -> status == :error end)
  end

  # Ethermass.Monitoring.update_all_eth_balance()
  def update_all_eth_balance() do

    query = from i in MarketMaker,
            order_by: [desc: i.last_check]

    Repo.all(query)
    |> Enum.each(fn x ->

      :timer.sleep(500)

      update_balances_market_maker(x)

    end)
  end

  def update_balances_market_maker(%MarketMaker{} = market_maker) do

  market_maker =
    case ETH.Query.get_balance(market_maker.address) do
      {:ok, result} ->

        {:ok, updated_market_maker} = update_market_maker(market_maker, %{"eth_balance" => result, "last_check" => NaiveDateTime.utc_now})
        updated_market_maker
      _other ->
        IO.inspect("Error update_eth on, #{market_maker.address}")
        market_maker
    end

    case BaliverseContract.balance_of(market_maker.address) do
      {:ok, result} ->

        update_market_maker(market_maker, %{"nft_balance" => result, "last_check" => NaiveDateTime.utc_now})
      _other ->
        IO.inspect("Error update_nft on, #{market_maker.address}")
        :nothing
    end
  end

  # Ethermass.Monitoring.get_floor_price()
  def get_floor_price() do
    case HTTPoison.get("https://api.opensea.io/api/v1/collection/baliverse-nft") do
      {:ok, %HTTPoison.Response{body: body}} ->
        result = Jason.decode!(body)

        result["collection"]["stats"]["floor_price"]
      _other -> nil
    end
  end

# Ethermass.Monitoring.list_market_maker_summary()
  def list_market_maker_summary() do

    all_list = Ethermass.Monitoring.list_market_maker()

    floor_price = Ethermass.Monitoring.get_floor_price() || 0.0

   [
    %{
      name: "PT",
      capital: 109.5
    },
    %{
      name: "KKB",
      capital: 16.0
    },
    %{
      name: "IOG",
      capital: 31.0
    },
    %{
      name: "EBIT",
      capital: 23.5
    },
    %{
      name: "RSBBI",
      capital: 32.4
    },
    %{
      name: "BBG",
      capital: 34.6
    },
    %{
      name: "RGN",
      capital: 57.3
    }
  ]
  |> Enum.map(fn x ->

    group_list = all_list |> Enum.filter(fn y -> y.group == x.name end)


    eth_balance = group_list |> Enum.reduce(0, fn z, acc -> acc + z.eth_balance end)
    nft_balance = group_list |> Enum.reduce(0, fn z, acc -> acc + z.nft_balance end)
    wallet = group_list |> Enum.count()
    wallet_active = group_list |> Enum.filter(fn x -> x.nft_balance > 0 end) |> Enum.count

    est_nft_value = nft_balance * floor_price
    total_value = est_nft_value + eth_balance
    revenue = total_value - x.capital
    revenue_idr = revenue * 53000000
    return = (revenue / x.capital) * 100


    x
    |> Map.put(:nft_balance, nft_balance)
    |> Map.put(:eth_balance, eth_balance)
    |> Map.put(:wallet, wallet)
    |> Map.put(:wallet_active, wallet_active)
    |> Map.put(:nft_floor, floor_price)
    |> Map.put(:est_nft_value, est_nft_value)
    |> Map.put(:total_value, total_value)
    |> Map.put(:return, return)
    |> Map.put(:revenue, revenue)
    |> Map.put(:revenue_idr, revenue_idr)


  end)




  end



  @doc """
  Returns the list of market_maker.

  ## Examples

      iex> list_market_maker()
      [%MarketMaker{}, ...]

  """
  def list_market_maker do
    Repo.all(MarketMaker)
  end

  @doc """
  Gets a single market_maker.

  Raises `Ecto.NoResultsError` if the Market maker does not exist.

  ## Examples

      iex> get_market_maker!(123)
      %MarketMaker{}

      iex> get_market_maker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_market_maker!(id), do: Repo.get!(MarketMaker, id)

  @doc """
  Creates a market_maker.

  ## Examples

      iex> create_market_maker(%{field: value})
      {:ok, %MarketMaker{}}

      iex> create_market_maker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_market_maker(attrs \\ %{}) do
    %MarketMaker{}
    |> MarketMaker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a market_maker.

  ## Examples

      iex> update_market_maker(market_maker, %{field: new_value})
      {:ok, %MarketMaker{}}

      iex> update_market_maker(market_maker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_market_maker(%MarketMaker{} = market_maker, attrs) do
    market_maker
    |> MarketMaker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a market_maker.

  ## Examples

      iex> delete_market_maker(market_maker)
      {:ok, %MarketMaker{}}

      iex> delete_market_maker(market_maker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_market_maker(%MarketMaker{} = market_maker) do
    Repo.delete(market_maker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking market_maker changes.

  ## Examples

      iex> change_market_maker(market_maker)
      %Ecto.Changeset{data: %MarketMaker{}}

  """
  def change_market_maker(%MarketMaker{} = market_maker, attrs \\ %{}) do
    MarketMaker.changeset(market_maker, attrs)
  end
end
