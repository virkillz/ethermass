defmodule Ethermass.ContractFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ethermass.Contract` context.
  """

  @doc """
  Generate a smart_contract.
  """
  def smart_contract_fixture(attrs \\ %{}) do
    {:ok, smart_contract} =
      attrs
      |> Enum.into(%{
        abi: "some abi",
        label: "some label",
        metadata: "some metadata",
        network: "some network",
        type: "some type"
      })
      |> Ethermass.Contract.create_smart_contract()

    smart_contract
  end
end
