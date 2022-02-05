defmodule Ethermass.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias Ethermass.Repo

  alias Ethermass.Transaction.TransactionPlan
  alias Ethermass.Wallet

  @priority_fee_gwei 3

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

  # Ethermass.Transaction.validate_csv_mass_funding("mass_funding_template.csv")
  def validate_csv_mass_funding(file_path) do
    if File.exists?(file_path) do

      any_error =
      File.stream!(file_path)
      |> CSV.decode
      |> Enum.filter(fn {status, _value} -> status == :error end)
      |> List.first()

      case any_error do
        nil ->

        [_title | content] =
          File.stream!(file_path)
          |> CSV.decode
          |> Enum.map(fn {_status, value} -> value end)


        validation =
          content
          |> Enum.with_index()
          |> Enum.map(fn {value, index} ->

          all_addresses = Wallet.list_addresses_only()

          [from, to, eth_value] = value

          new_from = "0x" <> (from |> String.trim_leading("0x") |> String.upcase)
          new_to = "0x" <> (to |> String.trim_leading("0x") |> String.upcase)

          from_error =
            if Enum.member?(all_addresses, new_from) do
              ""
            else
              "from: #{new_from} not exist is address book. "
            end

          to_error =
            if Enum.member?(all_addresses, new_to) do
              ""
            else
              "to: not exist is address book. "
            end

          eth_value_error =
            case Float.parse(eth_value) do
              :error -> "value: must be float. "
              {_,_} -> ""
            end

          error = from_error <> to_error <> eth_value_error

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

        {:error, reason} -> {:error, reason}
      end
    else
      {:error, "File cannot be founded."}
    end
  end

  def validate_csv_mass_minting(file_path) do
    if File.exists?(file_path) do

      any_error =
      File.stream!(file_path)
      |> CSV.decode
      |> Enum.filter(fn {status, _value} -> status == :error end)
      |> List.first()

      case any_error do
        nil ->

        [_title | content] =
          File.stream!(file_path)
          |> CSV.decode
          |> Enum.map(fn {_status, value} -> value end)


        validation =
          content
          |> Enum.with_index()
          |> Enum.map(fn {value, index} ->

          all_addresses = Wallet.list_addresses_only()

          [from, nft, _group] = value

          new_from = "0x" <> (from |> String.trim_leading("0x") |> String.upcase)

          from_error =
            if Enum.member?(all_addresses, new_from) do
              ""
            else
              "from: #{new_from} not exist is address book. "
            end

          nft_error =
            case Integer.parse(nft) do
              {_,_} -> ""
              :error -> "nft: must be integer. "
            end

          error = from_error <> nft_error

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

        {:error, reason} -> {:error, reason}
      end
    else
      {:error, "File cannot be founded."}
    end
  end


  def validate_csv_mass_whitelist(file_path) do
    if File.exists?(file_path) do

      any_error =
      File.stream!(file_path)
      |> CSV.decode
      |> Enum.filter(fn {status, _value} -> status == :error end)
      |> List.first()

      case any_error do
        nil ->

        [_title | content] =
          File.stream!(file_path)
          |> CSV.decode
          |> Enum.map(fn {_status, value} -> value end)

          all_addresses = Wallet.list_addresses_only()

        validation =
          content
          |> Enum.with_index()
          |> Enum.map(fn {value, index} ->


          [from, _whitelist, amount] = value

          new_from = "0x" <> (from |> String.trim_leading("0x") |> String.upcase)

          from_error =
            if Enum.member?(all_addresses, new_from) do
              ""
            else
              "from: #{new_from} not exist is address book. "
            end

          amount_error =
            case Integer.parse(amount) do
              {_,_} -> ""
              :error -> "nft: must be integer. "
            end

          error = from_error <> amount_error

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

        {:error, reason} -> {:error, reason}
      end
    else
      {:error, "File cannot be founded."}
    end
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
  Creates a transaction_batch for mass funding.

  ## Examples

      iex> create_transaction_batch_mass_funding(%{field: value})
      {:ok, %TransactionBatch{}}

      iex> create_transaction_batch_mass_funding(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction_batch_mass_funding(attrs \\ %{}) do


    transaction_batch_changeset =
    %TransactionBatch{}
    |> TransactionBatch.changeset_mass_funding(attrs)


    Ecto.Multi.new()
    |> Ecto.Multi.insert(:transaction_batch, transaction_batch_changeset)
    |> Ecto.Multi.run(:transaction_plan, fn _repo, %{transaction_batch: transaction_batch} ->

      file_path = attrs["csv_source"]

      all_addresses = Ethermass.Wallet.list_addresses()

      [_title | content] =
      File.stream!(file_path)
      |> CSV.decode!
      |> Enum.map(fn x -> x end)

      result =
        content
        |> Enum.map(fn [from, to, value] ->

          new_from = "0x" <> (from |> String.trim_leading("0x") |> String.upcase)
          new_to = "0x" <> (to |> String.trim_leading("0x") |> String.upcase)

          IO.inspect(new_from)

          address =
            all_addresses
            |> Enum.filter(fn x -> x.eth_address == new_from end)
            |> List.first

          %{
            "from" => new_from,
            "to" => new_to,
            "gas_limit" => transaction_batch.gas_limit,
            "gas_price" => transaction_batch.gas_price,
            "network" => transaction_batch.network,
            "title" => transaction_batch.title,
            "transaction_type" => transaction_batch.type,
            "value" => value,
            "transaction_batch_id" => transaction_batch.id,
            "address_id" => address.id
          }
          |> create_transaction_plan()
        end)
        |> Enum.filter(fn {status, _value} -> status == :error end)

      if Enum.count(result) > 0 do
        {:error, "One of the transaction plan creation is failed."}
      else
        {:ok, :ok}
      end


    end)


    |> Repo.transaction()
  end

  def create_transaction_batch_mass_minting(attrs \\ %{}) do


    transaction_batch_changeset =
    %TransactionBatch{}
    |> TransactionBatch.changeset_mass_minting(attrs)


    Ecto.Multi.new()
    |> Ecto.Multi.insert(:transaction_batch, transaction_batch_changeset)
    |> Ecto.Multi.run(:transaction_plan, fn _repo, %{transaction_batch: transaction_batch} ->

      file_path = attrs["csv_source"]

      all_addresses = Ethermass.Wallet.list_addresses()

      [_title | content] =
      File.stream!(file_path)
      |> CSV.decode!
      |> Enum.map(fn x -> x end)

      result =
        content
        |> Enum.map(fn [from, nft, notes] ->

          {nft_count, _} = Integer.parse(nft)
          {minting_cost, _} = Float.parse(attrs["minting_cost"])

          new_from = "0x" <> (from |> String.trim_leading("0x") |> String.upcase)

          address =
            all_addresses
            |> Enum.filter(fn x -> x.eth_address == new_from end)
            |> List.first

          %{
            "from" => new_from,
            "to" => transaction_batch.to,
            "gas_limit" => transaction_batch.gas_limit,
            "gas_price" => transaction_batch.gas_price,
            "network" => transaction_batch.network,
            "title" => transaction_batch.title,
            "transaction_type" => transaction_batch.type,
            "value" => nft_count * minting_cost,
            "arguments" => "[#{nft_count}]",
            "transaction_batch_id" => transaction_batch.id,
            "address_id" => address.id,
            "remark" => notes
          }
          |> create_transaction_plan()
        end)
        |> Enum.filter(fn {status, _value} -> status == :error end)

      if Enum.count(result) > 0 do
        {:error, "One of the transaction plan creation is failed."}
      else
        {:ok, :ok}
      end


    end)


    |> Repo.transaction()
  end


  def create_transaction_batch_mass_whitelist(attrs \\ %{}) do


    transaction_batch_changeset =
    %TransactionBatch{}
    |> TransactionBatch.changeset_mass_whitelisting(attrs)


    Ecto.Multi.new()
    |> Ecto.Multi.insert(:transaction_batch, transaction_batch_changeset)
    |> Ecto.Multi.run(:transaction_plan, fn _repo, %{transaction_batch: transaction_batch} ->

      file_path = attrs["csv_source"]

      all_addresses = Ethermass.Wallet.list_addresses()

      [_title | content] =
      File.stream!(file_path)
      |> CSV.decode!
      |> Enum.map(fn x -> x end)

      result =
        content
        |> Enum.map(fn [from, whitelist, amount] ->

          {nft_amount, _} = Integer.parse(amount)

          new_from = "0x" <> (from |> String.trim_leading("0x") |> String.upcase)

          address =
            all_addresses
            |> Enum.filter(fn x -> x.eth_address == new_from end)
            |> List.first

          %{
            "from" => new_from,
            "to" => transaction_batch.to,
            "gas_limit" => transaction_batch.gas_limit,
            "gas_price" => transaction_batch.gas_price,
            "network" => transaction_batch.network,
            "title" => transaction_batch.title,
            "transaction_type" => transaction_batch.type,
            "value" => 0,
            "arguments" => "[#{whitelist},#{nft_amount}]",
            "transaction_batch_id" => transaction_batch.id,
            "address_id" => address.id
          }
          |> create_transaction_plan()
        end)
        |> Enum.filter(fn {status, _value} -> status == :error end)

      if Enum.count(result) > 0 do
        {:error, "One of the transaction plan creation is failed."}
      else
        {:ok, :ok}
      end


    end)


    |> Repo.transaction()
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

  def toggle_transaction_batch(%TransactionBatch{} = transaction_batch) do
    case transaction_batch.status do
      "unstarted" -> update_transaction_batch(transaction_batch, %{"status" => "in_progress"})
      "paused" -> update_transaction_batch(transaction_batch, %{"status" => "in_progress"})
      "in_progress" -> update_transaction_batch(transaction_batch, %{"status" => "paused"})
      "finished" -> {:error, "Process is already completed."}
    end
  end

  def list_in_progress_transaction_batch() do
    query = from i in TransactionBatch,
            where: i.status == "in_progress"

    Repo.all(query)
  end

  def run_all_transaction(%TransactionBatch{} = transaction_batch) do
    if transaction_batch.status != "in_progress" do
      {:error, "Transaction Batch is not running."}
    else
      query = from i in TransactionPlan,
              where: i.transaction_batch_id == ^transaction_batch.id,
              where: i.status == "unstarted"

      Repo.all(query)
      |> Enum.map(fn x ->

        :timer.sleep(500);
        run_transaction_plan(x)

      end)
    end
  end

  # Ethermass.Transaction.run_remaining_transaction(2)
  def run_remaining_transaction(transaction_batch_id) do

      query = from i in TransactionPlan,
              where: i.transaction_batch_id == ^transaction_batch_id,
              where: i.status == "unstarted" and is_nil(i.hash),
              order_by: (i.id),
              limit: 25

      Repo.all(query)
      |> Enum.map(fn x ->

        :timer.sleep(500);
        run_transaction_plan(x)

      end)
  end

  def check_and_update_transaction_batch_complete_status(transaction_batch_id) do
    batch = get_transaction_batch!(transaction_batch_id)

    case Enum.filter(batch.transaction_plan, fn x -> x.status != "success" end) do
      [] -> update_transaction_batch(batch, %{"status" => "finished"})
      _ -> :nothing
    end


  end

  def list_wait_confirmation_transaction_plan(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: i.status == "wait_confirmation" or i.status == "undefined"
            # where: i.status == "unstarted"

    Repo.all(query)
  end

  def run_all_wait_for_confirmation(%TransactionPlan{} = plan) do
    result = Ethermass.get_transaction_status(plan.hash)

    IO.inspect("Plan #{plan.id} : #{result}")

    update_transaction_plan(plan, %{"status" => result})
  end

  # Ethermass.Transaction.update_wait_for_confirmation(2)
  def update_wait_for_confirmation(transaction_batch_id) do
    list_wait_confirmation_transaction_plan(transaction_batch_id)
    |> Enum.map(fn x ->

      :timer.sleep(300);

      run_all_wait_for_confirmation(x)
    end)
  end

  # Ethermass.Transaction.get_status_summary(2)
  def get_status_summary(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id

    result = Repo.all(query)

    %{
      failed_with_tx: result |> Enum.filter(fn x -> x.status == "failed" && not is_nil(x.hash) end) |> Enum.count(),
      failed_without_tx: result |> Enum.filter(fn x -> x.status == "failed" && is_nil(x.hash) end) |> Enum.count(),
      success: result |> Enum.filter(fn x -> x.status == "success" end) |> Enum.count(),
      wait_confirmation: result |> Enum.filter(fn x -> x.status == "wait_confirmation" end) |> Enum.count(),
      undefined: result |> Enum.filter(fn x -> x.status == "undefined" end) |> Enum.count(),
      unstarted: result |> Enum.filter(fn x -> x.status == "unstarted" end) |> Enum.count(),
      postponed: result |> Enum.filter(fn x -> x.status == "postponed" end) |> Enum.count(),
      total: result |> Enum.count()
    }


  end

  def run_transaction_plan(%TransactionPlan{} = plan) do
    if is_nil(plan.hash) do
      case plan.transaction_type do
        "eth_transfer" -> run_send_eth_plan(plan)
        "nft_minting" -> run_mint_nft_plan(plan)
        "nft_whitelisting" -> run_nft_whitelist_plan(plan)
        _other -> {:error, "Not yet implemented"}
      end
    else
      {:error, "Plan already have tx address."}
    end
  end

  # Ethermass.Transaction.run_send_eth_plan()
  def run_send_eth_plan(%TransactionPlan{} = plan) do
    case update_transaction_plan(plan, %{"status" => "in_progress"}) do
      {:ok, plan} ->
        priv_key = Ethermass.Wallet.get_private_key(plan.from)

        value = floor(plan.value * 1_000_000_000_000_000_000)

        data = %{to: plan.to, gas_limit: plan.gas_limit |> to_hex, gas_price: plan.gas_price * 1_000_000_000 |> to_hex, from: plan.from, value: value}

        case ETH.send_transaction(data, priv_key) do
          {:ok, hash} -> update_transaction_plan(plan, %{"status" => "wait_confirmation", "hash" => hash})
          error -> IO.inspect(error)
            update_transaction_plan(plan, %{"status" => "failed", "remark" => inspect(error)})
        end

       {:error, _} -> {:error, "Cannot change status to in_progress"}
    end
  end

  # Ethermass.Transaction.fund_address("0xF86613BCF16C855446409F7F40A1AD9D9AB70A49", "0xC9C35A8FD6C117BE5619B6E28AD8F50B921E9B10", 0.1)
  def fund_address(from, to, value) do
    priv_key = Ethermass.Wallet.get_private_key(from)

    value = floor(value * 1_000_000_000_000_000_000)

    data = %{to: to, gas_limit: 100_000 |> to_hex, gas_price: 3 * 1_000_000_000 |> to_hex, from: from, value: value}

    ETH.send_transaction(data, priv_key)
  end

  def run_mint_nft_plan(%TransactionPlan{} = plan) do

    priv_key = Ethermass.Wallet.get_private_key(plan.from)

    value = floor(plan.value * 1_000_000_000_000_000_000)

    update_transaction_plan(plan, %{"status" => "in_progress"})

    data =
      ABI.encode("mint(uint256)", Jason.decode!(plan.arguments))
      |> Base.encode16(case: :lower)

    payload = %{to: plan.to, gas_limit: plan.gas_limit |> to_hex, gas_price: plan.gas_price * 1_000_000_000 |> to_hex, from: plan.from, value: value, data: "0x" <> data}


    # params = %{to: plan.to, gas_limit: 10_000_000 |> to_hex, gas_price: 3000000000 |> to_hex, from: "0xf86613BCf16C855446409F7F40a1ad9D9AB70A49", value: 500_000_000_000_000, data: "0x" <> data}

    # IO.inspect(payload)
    # ETH.send_transaction(params, private_key)



    case ETH.send_transaction(payload, priv_key) do
      {:ok, hash} -> update_transaction_plan(plan, %{"status" => "wait_confirmation", "hash" => hash})
      error -> IO.inspect(error)
        update_transaction_plan(plan, %{"status" => "failed", "remark" => inspect(error)})
    end
  end

  def run_nft_whitelist_plan(%TransactionPlan{} = plan) do


    case ETH.Query.gas_price() do
      {:ok, wei} ->
        base_price_gwei = round(wei / 1000_000_000)

        priority_fee_gwei = @priority_fee_gwei

        old_total_gas = base_price_gwei + priority_fee_gwei

        total_gas =
        if old_total_gas < 88, do: 88, else: old_total_gas

        if total_gas > plan.gas_price do
          update_transaction_plan(plan, %{"status" => "postponed", "remark" => "Base gas price #{base_price_gwei} and priority fee is higher than limit #{plan.gas_price}"})
        else
          priv_key = Ethermass.Wallet.get_private_key(plan.from)

          update_transaction_plan(plan, %{"status" => "in_progress"})


          [string_address, amount] =
            plan.arguments
            |> String.replace("[0", "[\"0")
            |> String.replace(",", "\",")
            |> Jason.decode!()

          {:ok, address}  = EthContract.Util.address_to_bytes(string_address)

          data =
            ABI.encode("whitelistUsers(address, uint256)", [address, amount])
            |> Base.encode16(case: :lower)

          payload = %{to: plan.to, gas_limit: plan.gas_limit |> to_hex, gas_price: total_gas * 1_000_000_000 |> to_hex, from: plan.from, value: 0, data: "0x" <> data}

          case ETH.send_transaction(payload, priv_key) do
            {:ok, hash} -> update_transaction_plan(plan, %{"status" => "wait_confirmation", "hash" => hash, "remark" => "Gas price: #{total_gas}"})
            error -> IO.inspect(error)
              update_transaction_plan(plan, %{"status" => "failed", "remark" => inspect(error)})
          end
        end


      {:error, _} -> update_transaction_plan(plan, %{"status" => "postponed", "remark" => "Cannot get base price. Network issue. "})
    end



  end


  # Ethermass.Transaction.update_all_whitelist_count(1)
  def update_all_whitelist_count(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: not is_nil(i.hash),
            where: is_nil(i.whitelist_count) or i.whitelist_count == 0

    Repo.all(query)
    |> Enum.map(fn x ->

      :timer.sleep(300);

      update_whitelist_count(x)

    end)
  end

   # Ethermass.Transaction.update_all_nft_balance(1)
   def update_all_nft_balance(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: not is_nil(i.hash),
            where: is_nil(i.nft_balance) or i.nft_balance == 0

    Repo.all(query)
    |> Enum.map(fn x ->

      :timer.sleep(300);

      update_nft_balance(x)

    end)
  end

  # Ethermass.Transaction.miss_whitelist(2)
  def miss_whitelist(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id

    table_data =
      Repo.all(query)
      |> Enum.map(fn x ->

        [string_address, amount] =
          x.arguments
          |> String.replace("[0", "[\"0")
          |> String.replace(",", "\",")
          |> Jason.decode!()

      %{
        address: string_address,
        whitelisted_count: amount,
        nft_balance: x.nft_balance,
      }

      end)
      |> Enum.filter(fn x ->

      x.whitelisted_count > x.nft_balance

      end)
      |> Enum.map(fn x ->

        [x.address, x.whitelisted_count, x.nft_balance]

      end)

    file = File.open!("test.csv", [:write, :utf8])
    table_data |> CSV.encode |> Enum.each(&IO.write(file, &1))




  end

  # Ethermass.Transaction.whitelist_count(23)
  def whitelist_count(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: not is_nil(i.whitelist_count) and i.whitelist_count > 0,
            select: count(i.id)

    Repo.one(query)
  end

  # Ethermass.Transaction.reset_undefined_plan(23)
  def reset_undefined_plan(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: i.status == "undefined"

    Repo.all(query)
    |> Enum.map(fn x -> update_transaction_plan(x, %{"hash" => nil, "status" => "unstarted", "attempt" => (x.attempt || 0) + 1}) end)
  end

  # Ethermass.Transaction.reset_failed_plan(2)
  def reset_failed_plan(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: i.status == "failed"

    Repo.all(query)
    |> Enum.map(fn x -> update_transaction_plan(x, %{"hash" => nil, "status" => "unstarted", "attempt" => (x.attempt || 0) + 1}) end)
  end


  # Ethermass.Transaction.reset_postponed_plan(2)
  def reset_postponed_plan(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: i.status == "postponed"

    Repo.all(query)
    |> Enum.map(fn x -> update_transaction_plan(x, %{"hash" => nil, "status" => "unstarted", "attempt" => (x.attempt || 0) + 1}) end)
  end

  # Ethermass.Transaction.release_pending_whitelist_tx(63,80,140)
  def release_pending_whitelist_tx(transaction_plan_id, nonce, gas_price) do
    plan = get_transaction_plan!(transaction_plan_id)


      priv_key = Ethermass.Wallet.get_private_key(plan.from)

      update_transaction_plan(plan, %{"status" => "in_progress"})


      [string_address, amount] =
        plan.arguments
        |> String.replace("[0", "[\"0")
        |> String.replace(",", "\",")
        |> Jason.decode!()

      {:ok, address}  = EthContract.Util.address_to_bytes(string_address)

      data =
        ABI.encode("whitelistUsers(address, uint256)", [address, amount])
        |> Base.encode16(case: :lower)

      payload = %{to: plan.to, nonce: nonce, gas_limit: plan.gas_limit |> to_hex, gas_price: gas_price * 1_000_000_000 |> to_hex, from: plan.from, value: 0, data: "0x" <> data}

      case ETH.send_transaction(payload, priv_key) do
        {:ok, hash} -> update_transaction_plan(plan, %{"status" => "wait_confirmation", "hash" => hash})
        error -> IO.inspect(error)
          update_transaction_plan(plan, %{"status" => "failed", "remark" => inspect(error)})
      end


  end


  # Ethermass.Transaction.get_transaction_plan!(601) |> Ethermass.Transaction.update_whitelist_count()
  def update_whitelist_count(%TransactionPlan{} = plan) do
    if plan.transaction_type == "nft_whitelisting" do

      address = plan.arguments |> String.split(",") |> List.first() |> String.replace("[", "")

      case BaliverseContract.is_whitelisted(address) do
        {:error, error} -> {:error, error}
        number -> update_transaction_plan(plan, %{"whitelist_count" => number})
      end

    else
      {:error, "Not NFT whitelist type"}
    end
  end

  def update_nft_balance(%TransactionPlan{} = plan) do
    if plan.transaction_type == "nft_whitelisting" do

      address = plan.arguments |> String.split(",") |> List.first() |> String.replace("[", "")

      case BaliverseContract.balance_of(address) do
        {:error, error} -> {:error, error}
        {:ok, number} -> update_transaction_plan(plan, %{"nft_balance" => number})
      end

    else
      {:error, "Not NFT whitelist type"}
    end
  end

  # Ethermass.Transaction.success_count(23)
  def success_count(transaction_batch_id) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: not is_nil(i.hash),
            select: count(i.id)

    Repo.one(query)
  end

  # Ethermass.Transaction.update_all_gas_fee(1, 127)
  def update_all_gas_fee(transaction_batch_id, new_max_gas_price) do
    query = from i in TransactionPlan,
            where: i.transaction_batch_id == ^transaction_batch_id,
            where: is_nil(i.hash)

    Repo.all(query)
    |> Enum.map(fn x ->

      update_transaction_plan(x, %{"gas_price" => new_max_gas_price})

    end)
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
      "transaction_type" => "eth_transfer",
      "value" => value,
      "transaction_batch_id" => transaction_batch_id,
      "address_id" => address_id
    }
    |> create_transaction_plan()
  end


  def create_mint_plan(from, to, value, gas_price, title, transaction_batch_id, address_id) do
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
