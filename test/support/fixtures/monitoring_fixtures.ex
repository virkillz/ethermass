defmodule Ethermass.MonitoringFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Ethermass.Monitoring` context.
  """

  @doc """
  Generate a unique owner_list token_id.
  """
  def unique_owner_list_token_id, do: System.unique_integer([:positive])

  @doc """
  Generate a owner_list.
  """
  def owner_list_fixture(attrs \\ %{}) do
    {:ok, owner_list} =
      attrs
      |> Enum.into(%{
        address: "some address",
        last_check: ~N[2022-01-29 06:48:00],
        remark: "some remark",
        token_id: unique_owner_list_token_id(),
        token_type: "some token_type"
      })
      |> Ethermass.Monitoring.create_owner_list()

    owner_list
  end

  @doc """
  Generate a market_maker.
  """
  def market_maker_fixture(attrs \\ %{}) do
    {:ok, market_maker} =
      attrs
      |> Enum.into(%{
        address: "some address",
        eth_balance: 120.5,
        group: "some group",
        last_check: ~N[2022-01-30 09:27:00],
        nft_balance: 42
      })
      |> Ethermass.Monitoring.create_market_maker()

    market_maker
  end
end
