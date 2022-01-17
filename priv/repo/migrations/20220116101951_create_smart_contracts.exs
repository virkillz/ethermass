defmodule Ethermass.Repo.Migrations.CreateSmartContracts do
  use Ecto.Migration

  def change do
    create table(:smart_contracts) do
      add :label, :string
      add :address, :string
      add :type, :string
      add :abi, :text
      add :metadata, :text
      add :network, :string

      timestamps()
    end
  end
end
