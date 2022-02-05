defmodule Ethermass.Monitoring.OwnerList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "owner_list" do
    field :address, :string
    field :last_check, :naive_datetime
    field :remark, :string
    field :token_id, :integer
    field :token_type, :string

    timestamps()
  end

  @doc false
  def changeset(owner_list, attrs) do
    owner_list
    |> cast(attrs, [:token_id, :address, :last_check, :token_type, :remark])
    |> validate_required([:token_id, :address, :last_check])
    |> unique_constraint(:token_id)
  end
end
