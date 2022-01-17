defmodule Ethermass.Repo.Migrations.AddEthBalanceToAddress do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :eth_balance, :float
    end
  end
end
