defmodule Ethermass.Repo.Migrations.AddBatchToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transaction_plans) do
      add :transaction_batch_id, references(:transaction_batch, on_delete: :nothing)
    end

    create index(:transaction_plans, [:transaction_batch_id])
  end
end
