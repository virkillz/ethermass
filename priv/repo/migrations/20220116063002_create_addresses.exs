defmodule Ethermass.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :eth_address, :string
      add :mneumonic_phrase, :text
      add :public_key, :text
      add :private_key, :text
      add :remark, :text
      add :label, :string

      timestamps()
    end

    create unique_index(:addresses, [:eth_address])
  end
end
