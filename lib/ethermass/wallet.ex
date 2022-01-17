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
    query = from i in Address,
          order_by: i.id
    Repo.all(query)
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
    query = from i in Address,
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

  def update_eth_balance(%Address{} = address) do
    case ETH.Query.get_balance(address.eth_address) do
      {:ok, result} ->
        {:ok, updated_address} = update_address(address, %{"eth_balance" => result})
        updated_address
      _other -> address
    end
  end

  def generate_address(attrs \\ %{}) do
    IO.inspect(attrs)
    %Address{}
    |> Address.changeset_generate(attrs)
    |> generate_address_recursion(attrs)
    # |> Repo.insert()
  end


  def generate_address_recursion(%Ecto.Changeset{valid?: false} = changeset, _attrs) do
    Repo.insert(changeset)
  end

  def generate_address_recursion(%Ecto.Changeset{valid?: true} = changeset, attrs) do

    how_many = attrs["how_many"] |> String.to_integer()

    if how_many > 1 do

      Range.new(1,how_many)
      |> Enum.to_list()
      |> Enum.map(fn x ->

        new_label = attrs["label"] <> " #{x}"

        attrs
        |> Map.put("label", new_label)
        |> Map.put("how_many", "1")
        |> generate_address()

      end)
      |> List.last


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
