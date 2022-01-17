defmodule Ethermass.Transaction.TransactionBatch do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction_batch" do
    field :gas_limit, :integer
    field :gas_price, :integer
    field :network, :string
    field :status, :string, default: "unstarted"
    field :title, :string
    field :to, :string
    field :type, :string
    field :value, :float

    timestamps()

    has_many :transaction_plan, Ethermass.Transaction.TransactionPlan
  end

  @doc false
  def changeset(transaction_batch, attrs) do
    transaction_batch
    |> cast(attrs, [:title, :type, :status, :to, :gas_price, :gas_limit, :network, :value])
    |> validate_required([:title, :type, :gas_price, :gas_limit, :network])
  end
end
