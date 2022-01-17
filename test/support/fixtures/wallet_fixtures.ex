defmodule Ethermass.WalletFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ethermass.Wallet` context.
  """

  @doc """
  Generate a unique address eth_address.
  """
  def unique_address_eth_address, do: "some eth_address#{System.unique_integer([:positive])}"

  @doc """
  Generate a address.
  """
  def address_fixture(attrs \\ %{}) do
    {:ok, address} =
      attrs
      |> Enum.into(%{
        eth_address: unique_address_eth_address(),
        label: "some label",
        mneumonic_phrase: "some mneumonic_phrase",
        private_key: "some private_key",
        public_key: "some public_key",
        remark: "some remark"
      })
      |> Ethermass.Wallet.create_address()

    address
  end
end
