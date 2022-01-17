defmodule Ethermass.Repo.Migrations.AddStatusToTransactionBatch do
  use Ecto.Migration

  def change do
    alter table(:transaction_batch) do
      add :status, :string
    end
  end
end
