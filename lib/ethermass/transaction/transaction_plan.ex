defmodule Ethermass.Transaction.TransactionPlan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction_plans" do
    field :arguments, :string
    field :attempt, :integer, default: 0
    field :from, :string
    field :function, :string
    field :gas_fee, :integer
    field :gas_limit, :integer
    field :gas_price, :integer
    field :hash, :string
    field :network, :string
    field :remark, :string
    field :status, :string, default: "unstarted"
    field :title, :string
    field :to, :string
    field :transaction_type, :string
    field :value, :float
    field :address_id, :id
    field :transaction_batch_id, :id
    field :smart_contract_id, :id
    field :nft_balance, :integer
    field :whitelist_count, :integer

    has_one :smart_contract, Ethermass.Contract.SmartContract, foreign_key: :smart_contract_id

    timestamps()
  end

  @doc false
  def changeset(transaction_plan, attrs) do
    transaction_plan
    |> cast(attrs, [:title, :nft_balance, :whitelist_count, :smart_contract_id, :transaction_batch_id, :address_id, :remark, :transaction_type, :function, :from, :to, :arguments, :hash, :network, :status, :attempt, :value, :gas_price, :gas_limit, :gas_fee])
    |> validate_required([:title, :transaction_type, :from, :to, :network, :value, :gas_price, :gas_limit])
  end
end
