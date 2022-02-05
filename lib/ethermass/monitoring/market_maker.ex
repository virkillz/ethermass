defmodule Ethermass.Monitoring.MarketMaker do
  use Ecto.Schema
  import Ecto.Changeset

  schema "market_maker" do
    field :address, :string
    field :eth_balance, :float
    field :group, :string
    field :last_check, :naive_datetime
    field :nft_balance, :integer

    timestamps()
  end

  @doc false
  def changeset(market_maker, attrs) do
    market_maker
    |> cast(attrs, [:address, :group, :nft_balance, :eth_balance, :last_check])
    |> validate_required([:address, :group])
    |> unique_constraint(:address)
  end
end
