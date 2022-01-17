defmodule Ethermass.TransactionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ethermass.Transaction` context.
  """

  @doc """
  Generate a transaction_plan.
  """
  def transaction_plan_fixture(attrs \\ %{}) do
    {:ok, transaction_plan} =
      attrs
      |> Enum.into(%{
        arguments: "some arguments",
        attempt: 42,
        from: "some from",
        function: "some function",
        gas_fee: 42,
        gas_limit: 42,
        gas_price: 42,
        hash: "some hash",
        network: "some network",
        remark: "some remark",
        status: "some status",
        title: "some title",
        to: "some to",
        transaction_type: "some transaction_type",
        value: 120.5
      })
      |> Ethermass.Transaction.create_transaction_plan()

    transaction_plan
  end

  @doc """
  Generate a transaction_batch.
  """
  def transaction_batch_fixture(attrs \\ %{}) do
    {:ok, transaction_batch} =
      attrs
      |> Enum.into(%{
        gas_limit: 42,
        gas_price: 42,
        network: "some network",
        title: "some title",
        to: "some to",
        type: "some type",
        value: 120.5
      })
      |> Ethermass.Transaction.create_transaction_batch()

    transaction_batch
  end
end
