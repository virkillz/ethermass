defmodule Ethermass.Repo.Migrations.AddNftBalanceToAddress do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      add :nft_balance, :integer
    end
  end
end
