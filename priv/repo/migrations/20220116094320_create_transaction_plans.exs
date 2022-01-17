defmodule Ethermass.Repo.Migrations.CreateTransactionPlans do
  use Ecto.Migration

  def change do
    create table(:transaction_plans) do
      add :title, :string
      add :remark, :text
      add :transaction_type, :string
      add :function, :string
      add :from, :string
      add :to, :string
      add :arguments, :text
      add :hash, :string
      add :network, :string
      add :status, :string
      add :attempt, :integer
      add :value, :float
      add :gas_price, :integer
      add :gas_limit, :integer
      add :gas_fee, :integer
      add :address_id, references(:addresses, on_delete: :nothing)

      timestamps()
    end

    create index(:transaction_plans, [:address_id])
  end
end
