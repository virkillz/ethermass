defmodule Ethermass.Repo.Migrations.CreateMarketMaker do
  use Ecto.Migration

  def change do
    create table(:market_maker) do
      add :address, :string
      add :group, :string
      add :nft_balance, :integer
      add :eth_balance, :float
      add :last_check, :naive_datetime

      timestamps()
    end

    create unique_index(:market_maker, [:address])
  end
end
