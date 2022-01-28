defmodule Ethermass.Transaction.TransactionBatch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ethermass.Transaction

  schema "transaction_batch" do
    field :gas_limit, :integer
    field :gas_price, :integer
    field :network, :string
    field :status, :string, default: "unstarted"
    field :title, :string
    field :to, :string
    field :type, :string
    field :value, :float
    field :csv_source, :string, virtual: true
    field :minting_cost, :float, virtual: true

    timestamps()

    has_many :transaction_plan, Ethermass.Transaction.TransactionPlan
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(transaction_batch, attrs) do
    transaction_batch
    |> cast(attrs, [:title, :csv_source, :type, :status, :to, :gas_price, :gas_limit, :network, :value])
    |> validate_required([:title, :type, :gas_price, :gas_limit, :network])
  end

  def changeset_mass_funding(transaction_batch, attrs) do
    transaction_batch
    |> cast(attrs, [:title, :csv_source, :type, :status, :to, :gas_price, :gas_limit, :network, :value])
    |> put_change(:type, "eth_transfer")
    |> put_change(:network, Ethermass.get_network())
    |> validate_required([:title, :gas_price, :gas_limit, :csv_source ])
    |> validate_mass_funding_csv_source()
  end

  def changeset_mass_whitelisting(transaction_batch, attrs) do
    transaction_batch
    |> cast(attrs, [:title, :csv_source, :type, :status, :to, :gas_price, :gas_limit, :network, :value])
    |> put_change(:type, "nft_whitelisting")
    |> put_change(:network, Ethermass.get_network())
    |> validate_required([:title, :gas_price, :gas_limit, :csv_source ])
    |> validate_mass_whitelisting_csv_source()
  end

  def changeset_mass_minting(transaction_batch, attrs) do
    transaction_batch
    |> cast(attrs, [:title, :csv_source, :to, :gas_price, :gas_limit, :minting_cost])
    |> put_change(:type, "nft_minting")
    |> put_change(:network, Ethermass.get_network())
    |> validate_required([:title, :gas_price, :to, :gas_limit, :csv_source, :minting_cost])
    |> validate_mass_minting_csv_source()
  end

  def validate_mass_funding_csv_source(changeset) do
    csv_file = get_field(changeset, :csv_source)

    if is_nil(csv_file) do
      changeset
    else
      case Transaction.validate_csv_mass_funding(csv_file) do
        {:ok, _} -> changeset
        {:error, reason} -> add_error(changeset, :csv_source, reason)
      end
    end
  end

  def validate_mass_whitelisting_csv_source(changeset) do
    csv_file = get_field(changeset, :csv_source)

    if is_nil(csv_file) do
      changeset
    else
      case Transaction.validate_csv_mass_whitelist(csv_file) do
        {:ok, _} -> changeset
        {:error, reason} -> add_error(changeset, :csv_source, reason)
      end
    end
  end

  def validate_mass_minting_csv_source(changeset) do
    csv_file = get_field(changeset, :csv_source)

    if is_nil(csv_file) do
      changeset
    else
      case Transaction.validate_csv_mass_minting(csv_file) do
        {:ok, _} -> changeset
        {:error, reason} -> add_error(changeset, :csv_source, reason)
      end
    end
  end
end
