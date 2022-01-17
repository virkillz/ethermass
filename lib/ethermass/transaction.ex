defmodule Ethermass.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias Ethermass.Repo

  alias Ethermass.Transaction.TransactionPlan

  @doc """
  Returns the list of transaction_plans.

  ## Examples

      iex> list_transaction_plans()
      [%TransactionPlan{}, ...]

  """
  def list_transaction_plans do
    Repo.all(TransactionPlan)
  end

  @doc """
  Gets a single transaction_plan.

  Raises `Ecto.NoResultsError` if the Transaction plan does not exist.

  ## Examples

      iex> get_transaction_plan!(123)
      %TransactionPlan{}

      iex> get_transaction_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction_plan!(id), do: Repo.get!(TransactionPlan, id)

  @doc """
  Creates a transaction_plan.

  ## Examples

      iex> create_transaction_plan(%{field: value})
      {:ok, %TransactionPlan{}}

      iex> create_transaction_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction_plan(attrs \\ %{}) do
    %TransactionPlan{}
    |> TransactionPlan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction_plan.

  ## Examples

      iex> update_transaction_plan(transaction_plan, %{field: new_value})
      {:ok, %TransactionPlan{}}

      iex> update_transaction_plan(transaction_plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction_plan(%TransactionPlan{} = transaction_plan, attrs) do
    transaction_plan
    |> TransactionPlan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction_plan.

  ## Examples

      iex> delete_transaction_plan(transaction_plan)
      {:ok, %TransactionPlan{}}

      iex> delete_transaction_plan(transaction_plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction_plan(%TransactionPlan{} = transaction_plan) do
    Repo.delete(transaction_plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction_plan changes.

  ## Examples

      iex> change_transaction_plan(transaction_plan)
      %Ecto.Changeset{data: %TransactionPlan{}}

  """
  def change_transaction_plan(%TransactionPlan{} = transaction_plan, attrs \\ %{}) do
    TransactionPlan.changeset(transaction_plan, attrs)
  end

  alias Ethermass.Transaction.TransactionBatch

  @doc """
  Returns the list of transaction_batch.

  ## Examples

      iex> list_transaction_batch()
      [%TransactionBatch{}, ...]

  """
  def list_transaction_batch do
    query = from i in TransactionBatch, preload: [:transaction_plan]
    Repo.all(query)
  end

  @doc """
  Gets a single transaction_batch.

  Raises `Ecto.NoResultsError` if the Transaction batch does not exist.

  ## Examples

      iex> get_transaction_batch!(123)
      %TransactionBatch{}

      iex> get_transaction_batch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction_batch!(id) do

    query = from i in TransactionBatch,
            where: i.id == ^id,
            preload: [:transaction_plan]

  Repo.one!(query)

  end

  @doc """
  Creates a transaction_batch.

  ## Examples

      iex> create_transaction_batch(%{field: value})
      {:ok, %TransactionBatch{}}

      iex> create_transaction_batch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction_batch(attrs \\ %{}) do
    %TransactionBatch{}
    |> TransactionBatch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction_batch.

  ## Examples

      iex> update_transaction_batch(transaction_batch, %{field: new_value})
      {:ok, %TransactionBatch{}}

      iex> update_transaction_batch(transaction_batch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction_batch(%TransactionBatch{} = transaction_batch, attrs) do
    transaction_batch
    |> TransactionBatch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction_batch.

  ## Examples

      iex> delete_transaction_batch(transaction_batch)
      {:ok, %TransactionBatch{}}

      iex> delete_transaction_batch(transaction_batch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction_batch(%TransactionBatch{} = transaction_batch) do
    Repo.delete(transaction_batch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction_batch changes.

  ## Examples

      iex> change_transaction_batch(transaction_batch)
      %Ecto.Changeset{data: %TransactionBatch{}}

  """
  def change_transaction_batch(%TransactionBatch{} = transaction_batch, attrs \\ %{}) do
    TransactionBatch.changeset(transaction_batch, attrs)
  end


  # Ethermass.Transaction.run_send_eth_plan()
  def run_send_eth_plan(plan_id) do
    plan = get_transaction_plan!(plan_id) |> IO.inspect()

    priv_key = Ethermass.Wallet.get_private_key(plan.from)

    value = floor(plan.value * 1_000_000_000_000_000_000)

    data = %{to: plan.to, gas_limit: plan.gas_limit |> to_hex, gas_price: plan.gas_price * 1_000_000_000 |> to_hex, from: plan.from, value: value}

    update_transaction_plan(plan, %{"status" => "started"})

    case ETH.send_transaction(data, priv_key) do
      {:ok, hash} -> update_transaction_plan(plan, %{"status" => "wait_confirmation", "hash" => hash})
      error -> IO.inspect(error)
        update_transaction_plan(plan, %{"status" => "failed"})
    end
  end

  def to_hex(something) do
    "0x" <> Hexate.encode(something)
  end

  def test(id) do
    address = Ethermass.Wallet.get_address!(id)
    batch = Ethermass.Transaction.get_transaction_batch!(1)

    create_send_eth_plan("0xF86613BCF16C855446409F7F40A1AD9D9AB70A49", address.eth_address, 0.0015, 3, batch.title, batch.id, address.id)
  end

  def create_send_eth_plan(from, to, value, gas_price, title, transaction_batch_id, address_id) do
    %{
      "from" => from,
      "to" => to,
      "gas_limit" => 30000,
      "gas_price" => gas_price,
      "network" => Application.get_env(:ethereumex, :network),
      "title" => title,
      "transaction_type" => "ETH transfer",
      "value" => value,
      "transaction_batch_id" => transaction_batch_id,
      "address_id" => address_id
    }
    |> create_transaction_plan()
  end


end