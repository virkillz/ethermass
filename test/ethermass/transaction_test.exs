defmodule Ethermass.TransactionTest do
  use Ethermass.DataCase

  alias Ethermass.Transaction

  describe "transaction_plans" do
    alias Ethermass.Transaction.TransactionPlan

    import Ethermass.TransactionFixtures

    @invalid_attrs %{arguments: nil, attempt: nil, from: nil, function: nil, gas_fee: nil, gas_limit: nil, gas_price: nil, hash: nil, network: nil, remark: nil, status: nil, title: nil, to: nil, transaction_type: nil, value: nil}

    test "list_transaction_plans/0 returns all transaction_plans" do
      transaction_plan = transaction_plan_fixture()
      assert Transaction.list_transaction_plans() == [transaction_plan]
    end

    test "get_transaction_plan!/1 returns the transaction_plan with given id" do
      transaction_plan = transaction_plan_fixture()
      assert Transaction.get_transaction_plan!(transaction_plan.id) == transaction_plan
    end

    test "create_transaction_plan/1 with valid data creates a transaction_plan" do
      valid_attrs = %{arguments: "some arguments", attempt: 42, from: "some from", function: "some function", gas_fee: 42, gas_limit: 42, gas_price: 42, hash: "some hash", network: "some network", remark: "some remark", status: "some status", title: "some title", to: "some to", transaction_type: "some transaction_type", value: 120.5}

      assert {:ok, %TransactionPlan{} = transaction_plan} = Transaction.create_transaction_plan(valid_attrs)
      assert transaction_plan.arguments == "some arguments"
      assert transaction_plan.attempt == 42
      assert transaction_plan.from == "some from"
      assert transaction_plan.function == "some function"
      assert transaction_plan.gas_fee == 42
      assert transaction_plan.gas_limit == 42
      assert transaction_plan.gas_price == 42
      assert transaction_plan.hash == "some hash"
      assert transaction_plan.network == "some network"
      assert transaction_plan.remark == "some remark"
      assert transaction_plan.status == "some status"
      assert transaction_plan.title == "some title"
      assert transaction_plan.to == "some to"
      assert transaction_plan.transaction_type == "some transaction_type"
      assert transaction_plan.value == 120.5
    end

    test "create_transaction_plan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_transaction_plan(@invalid_attrs)
    end

    test "update_transaction_plan/2 with valid data updates the transaction_plan" do
      transaction_plan = transaction_plan_fixture()
      update_attrs = %{arguments: "some updated arguments", attempt: 43, from: "some updated from", function: "some updated function", gas_fee: 43, gas_limit: 43, gas_price: 43, hash: "some updated hash", network: "some updated network", remark: "some updated remark", status: "some updated status", title: "some updated title", to: "some updated to", transaction_type: "some updated transaction_type", value: 456.7}

      assert {:ok, %TransactionPlan{} = transaction_plan} = Transaction.update_transaction_plan(transaction_plan, update_attrs)
      assert transaction_plan.arguments == "some updated arguments"
      assert transaction_plan.attempt == 43
      assert transaction_plan.from == "some updated from"
      assert transaction_plan.function == "some updated function"
      assert transaction_plan.gas_fee == 43
      assert transaction_plan.gas_limit == 43
      assert transaction_plan.gas_price == 43
      assert transaction_plan.hash == "some updated hash"
      assert transaction_plan.network == "some updated network"
      assert transaction_plan.remark == "some updated remark"
      assert transaction_plan.status == "some updated status"
      assert transaction_plan.title == "some updated title"
      assert transaction_plan.to == "some updated to"
      assert transaction_plan.transaction_type == "some updated transaction_type"
      assert transaction_plan.value == 456.7
    end

    test "update_transaction_plan/2 with invalid data returns error changeset" do
      transaction_plan = transaction_plan_fixture()
      assert {:error, %Ecto.Changeset{}} = Transaction.update_transaction_plan(transaction_plan, @invalid_attrs)
      assert transaction_plan == Transaction.get_transaction_plan!(transaction_plan.id)
    end

    test "delete_transaction_plan/1 deletes the transaction_plan" do
      transaction_plan = transaction_plan_fixture()
      assert {:ok, %TransactionPlan{}} = Transaction.delete_transaction_plan(transaction_plan)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_transaction_plan!(transaction_plan.id) end
    end

    test "change_transaction_plan/1 returns a transaction_plan changeset" do
      transaction_plan = transaction_plan_fixture()
      assert %Ecto.Changeset{} = Transaction.change_transaction_plan(transaction_plan)
    end
  end

  describe "transaction_batch" do
    alias Ethermass.Transaction.TransactionBatch

    import Ethermass.TransactionFixtures

    @invalid_attrs %{gas_limit: nil, gas_price: nil, network: nil, title: nil, to: nil, type: nil, value: nil}

    test "list_transaction_batch/0 returns all transaction_batch" do
      transaction_batch = transaction_batch_fixture()
      assert Transaction.list_transaction_batch() == [transaction_batch]
    end

    test "get_transaction_batch!/1 returns the transaction_batch with given id" do
      transaction_batch = transaction_batch_fixture()
      assert Transaction.get_transaction_batch!(transaction_batch.id) == transaction_batch
    end

    test "create_transaction_batch/1 with valid data creates a transaction_batch" do
      valid_attrs = %{gas_limit: 42, gas_price: 42, network: "some network", title: "some title", to: "some to", type: "some type", value: 120.5}

      assert {:ok, %TransactionBatch{} = transaction_batch} = Transaction.create_transaction_batch(valid_attrs)
      assert transaction_batch.gas_limit == 42
      assert transaction_batch.gas_price == 42
      assert transaction_batch.network == "some network"
      assert transaction_batch.title == "some title"
      assert transaction_batch.to == "some to"
      assert transaction_batch.type == "some type"
      assert transaction_batch.value == 120.5
    end

    test "create_transaction_batch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_transaction_batch(@invalid_attrs)
    end

    test "update_transaction_batch/2 with valid data updates the transaction_batch" do
      transaction_batch = transaction_batch_fixture()
      update_attrs = %{gas_limit: 43, gas_price: 43, network: "some updated network", title: "some updated title", to: "some updated to", type: "some updated type", value: 456.7}

      assert {:ok, %TransactionBatch{} = transaction_batch} = Transaction.update_transaction_batch(transaction_batch, update_attrs)
      assert transaction_batch.gas_limit == 43
      assert transaction_batch.gas_price == 43
      assert transaction_batch.network == "some updated network"
      assert transaction_batch.title == "some updated title"
      assert transaction_batch.to == "some updated to"
      assert transaction_batch.type == "some updated type"
      assert transaction_batch.value == 456.7
    end

    test "update_transaction_batch/2 with invalid data returns error changeset" do
      transaction_batch = transaction_batch_fixture()
      assert {:error, %Ecto.Changeset{}} = Transaction.update_transaction_batch(transaction_batch, @invalid_attrs)
      assert transaction_batch == Transaction.get_transaction_batch!(transaction_batch.id)
    end

    test "delete_transaction_batch/1 deletes the transaction_batch" do
      transaction_batch = transaction_batch_fixture()
      assert {:ok, %TransactionBatch{}} = Transaction.delete_transaction_batch(transaction_batch)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_transaction_batch!(transaction_batch.id) end
    end

    test "change_transaction_batch/1 returns a transaction_batch changeset" do
      transaction_batch = transaction_batch_fixture()
      assert %Ecto.Changeset{} = Transaction.change_transaction_batch(transaction_batch)
    end
  end
end
