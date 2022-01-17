defmodule Ethermass.Contract.SmartContract do
  use Ecto.Schema
  import Ecto.Changeset

  schema "smart_contracts" do
    field :abi, :string
    field :label, :string
    field :address, :string
    field :metadata, :string
    field :network, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(smart_contract, attrs) do
    smart_contract
    |> cast(attrs, [:label, :type, :abi, :metadata, :network, :address])
    |> validate_required([:label, :type, :abi, :network, :address])
  end
end
