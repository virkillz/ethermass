defmodule Ethermass.Wallet do
  @moduledoc """
  The Wallet context.
  """

  import Ecto.Query, warn: false
  alias Ethermass.Repo

  alias Ethermass.Wallet.Address

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    query =
      from i in Address,
        order_by: i.id

    Repo.all(query)
  end

  def list_addresses_only do
    query =
      from i in Address,
        order_by: i.id,
        select: i.eth_address

    Repo.all(query)
  end

  def validate_csv_batch_import(file_path) do
    if File.exists?(file_path) do
      any_error =
        File.stream!(file_path)
        |> CSV.decode()
        |> Enum.filter(fn {status, _value} -> status == :error end)
        |> List.first()

      case any_error do
        nil ->
          [title | content] =
            File.stream!(file_path)
            |> CSV.decode()
            |> Enum.map(fn {_status, value} -> value end)

          if Enum.count(title) == 2 do
            validation =
              content
              |> Enum.with_index()
              |> Enum.map(fn {value, index} ->
                [address, priv_key] = value

                address_error =
                  if String.starts_with?(address, "0x") do
                    ""
                  else
                    "Address in wrong format. "
                  end

                private_key_error =
                  case Ethermass.private_key_to_address(priv_key) do
                    {:ok, _addr} -> ""
                    {:error, error} -> error
                  end

                error = address_error <> private_key_error

                if error == "" do
                  {:ok, value}
                else
                  {:error, "Error line #{index + 2}. " <> error}
                end
              end)
              |> Enum.filter(fn {status, _value} -> status == :error end)
              |> List.first()

            case validation do
              nil -> {:ok, file_path}
              {:error, reason} -> {:error, reason}
            end
          else
            {:error, "CSV format must be = address,private_key"}
          end

        {:error, reason} ->
          {:error, reason}
      end
    else
      {:error, "File cannot be founded."}
    end
  end

  # Ethermass.Wallet.list_addresses() |> Enum.filter(fn x -> x.id == 3 end) |>

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id)

  def get_private_key(address) do
    query =
      from i in Address,
        where: i.eth_address == ^address,
        select: i.private_key

    Repo.one(query)
  end

  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def import_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset_import(attrs)
    |> Repo.insert()
  end

  def batch_import_address(attrs \\ %{}) do
    changeset =
      %Address{}
      |> Address.changeset_batch_import(attrs)

    # |> Repo.insert()

    if changeset.valid? do
      IO.inspect("bener")
      file_path = attrs["csv_source"]

      [_title | content] =
        File.stream!(file_path)
        |> CSV.decode()
        |> Enum.map(fn {_status, value} -> value end)

      content
      |> Enum.map(fn [address, priv_key] ->
        case Ethermass.private_key_to_address(priv_key) do
          {:ok, address} ->
            %{
              "eth_address" => address.eth_address,
              "mneumonic_phrase" => address.mnemonic_phrase,
              "private_key" => address.private_key,
              "public_key" => address.public_key,
              "label" => attrs["label"]
            }
            |> create_address()

          {:error, reason} ->
            IO.inspect("Failed: #{address} . Reason: #{reason}")
            :error
        end
      end)

      {:ok, "success"}
    else
      IO.inspect("salah")
      {:error, Map.put(changeset, :action, :insert)}
    end
  end

  def count_owned_nft() do
    query =
      from i in Address,
        select: sum(i.nft_balance)

    Repo.one(query)
  end

  # Ethermass.Wallet.update_balance_nft()
  def update_balance_nft() do
    list_addresses()
    |> Enum.each(fn x ->
      :timer.sleep(500)
      update_nft_balance(x)
    end)
  end

  def get_address_by(:address, address) do
    query =
      from i in Address,
        where: i.eth_address == ^address

    Repo.one!(query)
  end

  # Ethermass.Wallet.update_all_eth_balance()
  def update_all_eth_balance() do
    list_addresses()
    |> Enum.each(fn x ->
      update_eth_balance(x)
      :timer.sleep(1000)
    end)
  end

  def update_eth_balance(%Address{} = address) do
    case ETH.Query.get_balance(address.eth_address) do
      {:ok, result} ->
        {:ok, updated_address} = update_address(address, %{"eth_balance" => result})
        updated_address

      _other ->
        address
    end
  end

  def update_nft_balance(%Address{} = address) do
    case BaliverseContract.balance_of(address.eth_address) do
      {:ok, result} ->
        {:ok, updated_address} = update_address(address, %{"nft_balance" => result})
        updated_address

      _other ->
        address
    end
  end

  def generate_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset_generate(attrs)
    |> generate_address_recursion(attrs)

    # |> Repo.insert()
  end

  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  def generate_address_recursion(%Ecto.Changeset{valid?: false} = changeset, _attrs) do
    Repo.insert(changeset)
  end

  def generate_address_recursion(%Ecto.Changeset{valid?: true} = changeset, attrs) do
    how_many = attrs["how_many"] |> String.to_integer()

    if how_many > 1 do
      Range.new(1, how_many)
      |> Enum.to_list()
      |> Enum.map(fn x ->
        new_label = attrs["label"] <> " #{x}"

        attrs
        |> Map.put("label", new_label)
        |> Map.put("how_many", "1")
        |> generate_address()
      end)
      |> List.last()
    else
      Repo.insert(changeset)
    end
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{data: %Address{}}

  """
  def change_address(%Address{} = address, attrs \\ %{}) do
    Address.changeset(address, attrs)
  end
end
