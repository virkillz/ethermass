defmodule Ethermass.Repo.Migrations.CreateTransactionBatch do
  use Ecto.Migration

  def change do
    create table(:transaction_batch) do
      add :title, :string
      add :type, :string
      add :to, :string
      add :gas_price, :integer
      add :gas_limit, :integer
      add :network, :string
      add :value, :float

      timestamps()
    end
  end
end
