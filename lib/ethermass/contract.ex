defmodule Ethermass.Contract do
  @moduledoc """
  The Contract context.
  """

  import Ecto.Query, warn: false
  alias Ethermass.Repo

  alias Ethermass.Contract.SmartContract

  @doc """
  Returns the list of smart_contracts.

  ## Examples

      iex> list_smart_contracts()
      [%SmartContract{}, ...]

  """
  def list_smart_contracts do
    Repo.all(SmartContract)
  end

  @doc """
  Gets a single smart_contract.

  Raises `Ecto.NoResultsError` if the Smart contract does not exist.

  ## Examples

      iex> get_smart_contract!(123)
      %SmartContract{}

      iex> get_smart_contract!(456)
      ** (Ecto.NoResultsError)

  """
  def get_smart_contract!(id), do: Repo.get!(SmartContract, id)

  @doc """
  Creates a smart_contract.

  ## Examples

      iex> create_smart_contract(%{field: value})
      {:ok, %SmartContract{}}

      iex> create_smart_contract(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_smart_contract(attrs \\ %{}) do
    %SmartContract{}
    |> SmartContract.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a smart_contract.

  ## Examples

      iex> update_smart_contract(smart_contract, %{field: new_value})
      {:ok, %SmartContract{}}

      iex> update_smart_contract(smart_contract, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_smart_contract(%SmartContract{} = smart_contract, attrs) do
    smart_contract
    |> SmartContract.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a smart_contract.

  ## Examples

      iex> delete_smart_contract(smart_contract)
      {:ok, %SmartContract{}}

      iex> delete_smart_contract(smart_contract)
      {:error, %Ecto.Changeset{}}

  """
  def delete_smart_contract(%SmartContract{} = smart_contract) do
    Repo.delete(smart_contract)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking smart_contract changes.

  ## Examples

      iex> change_smart_contract(smart_contract)
      %Ecto.Changeset{data: %SmartContract{}}

  """
  def change_smart_contract(%SmartContract{} = smart_contract, attrs \\ %{}) do
    SmartContract.changeset(smart_contract, attrs)
  end
end
