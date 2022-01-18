defmodule Ethermass.Repo.Migrations.AddSmartContractIdToTransactionPlan do
  use Ecto.Migration

  def change do
    alter table(:transaction_plans) do
      add :smart_contract_id, references(:smart_contracts, on_delete: :nothing)
    end

    create index(:transaction_plans, [:smart_contract_id])
  end
end
