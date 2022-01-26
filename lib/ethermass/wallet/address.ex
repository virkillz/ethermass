defmodule Ethermass.Wallet.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ethermass.Wallet

  schema "addresses" do
    field :eth_address, :string
    field :label, :string
    field :mneumonic_phrase, :string
    field :private_key, :string
    field :public_key, :string
    field :remark, :string
    field :how_many, :integer, virtual: true, default: 1
    field :csv_source, :string, virtual: true
    field :eth_balance, :float, default: 0.0
    field :nft_balance, :integer

    timestamps()
  end

  def changeset_import(address, attrs) do
    address
    |> cast(attrs, [:private_key, :label])
    |> validate_required([:private_key])
    |> import_address()
    |> unique_constraint(:eth_address)
  end

  def changeset_batch_import(address, attrs) do
    address
    |> cast(attrs, [:csv_source, :label])
    |> validate_required([:csv_source, :label])
    |> validate_csv_source()
  end

  def changeset_generate(address, attrs) do
    address
    |> cast(attrs, [:label, :how_many])
    |> validate_number(:how_many, greater_than: 0)
    |> generate_address()
  end

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:eth_address, :nft_balance, :eth_balance, :mneumonic_phrase, :public_key, :private_key, :remark, :label])
    |> validate_required([:eth_address, :mneumonic_phrase, :public_key, :private_key])
    |> unique_constraint(:eth_address)
  end

  def validate_csv_source(changeset) do
    csv_file = get_field(changeset, :csv_source)

    if is_nil(csv_file) do
      changeset
    else
      case Wallet.validate_csv_batch_import(csv_file) do
        {:ok, _} -> changeset
        {:error, reason} -> add_error(changeset, :csv_source, reason)
      end
    end
  end

  def import_address(changeset) do
    private_key = get_field(changeset, :private_key)

    if String.length(private_key) != 64 do
      add_error(changeset, :private_key, "Please check again your private key")
    else
      %{eth_address: eth_address, mnemonic_phrase: mnemonic_phrase, public_key: public_key} = ETH.Wallet.create(private_key)

      changeset
      |> put_change(:eth_address, eth_address)
      |> put_change(:mneumonic_phrase, mnemonic_phrase)
      |> put_change(:public_key, public_key)
    end
  end

  def generate_address(changeset) do

      %{eth_address: eth_address,
      mnemonic_phrase: mnemonic_phrase,
      private_key: private_key,
      public_key: public_key} = ETH.Wallet.create()

      changeset
      |> put_change(:eth_address, eth_address)
      |> put_change(:mneumonic_phrase, mnemonic_phrase)
      |> put_change(:public_key, public_key)
      |> put_change(:private_key, private_key)
  end



end
