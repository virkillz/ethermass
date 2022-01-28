defmodule Ethermass.Repo.Migrations.ResultCountToTransactionPlan do
  use Ecto.Migration

  def change do
    alter table(:transaction_plans) do
      add :nft_balance, :integer
      add :whitelist_count, :integer
    end
  end
end
