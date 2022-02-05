defmodule Ethermass.Repo.Migrations.CreateOwnerList do
  use Ecto.Migration

  def change do
    create table(:owner_list) do
      add :token_id, :integer
      add :address, :string
      add :last_check, :naive_datetime
      add :token_type, :string
      add :remark, :text

      timestamps()
    end

    create unique_index(:owner_list, [:token_id])
  end
end
