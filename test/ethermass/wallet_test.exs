defmodule Ethermass.WalletTest do
  use Ethermass.DataCase

  alias Ethermass.Wallet

  describe "addresses" do
    alias Ethermass.Wallet.Address

    import Ethermass.WalletFixtures

    @invalid_attrs %{eth_address: nil, label: nil, mneumonic_phrase: nil, private_key: nil, public_key: nil, remark: nil}

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Wallet.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Wallet.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      valid_attrs = %{eth_address: "some eth_address", label: "some label", mneumonic_phrase: "some mneumonic_phrase", private_key: "some private_key", public_key: "some public_key", remark: "some remark"}

      assert {:ok, %Address{} = address} = Wallet.create_address(valid_attrs)
      assert address.eth_address == "some eth_address"
      assert address.label == "some label"
      assert address.mneumonic_phrase == "some mneumonic_phrase"
      assert address.private_key == "some private_key"
      assert address.public_key == "some public_key"
      assert address.remark == "some remark"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wallet.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      update_attrs = %{eth_address: "some updated eth_address", label: "some updated label", mneumonic_phrase: "some updated mneumonic_phrase", private_key: "some updated private_key", public_key: "some updated public_key", remark: "some updated remark"}

      assert {:ok, %Address{} = address} = Wallet.update_address(address, update_attrs)
      assert address.eth_address == "some updated eth_address"
      assert address.label == "some updated label"
      assert address.mneumonic_phrase == "some updated mneumonic_phrase"
      assert address.private_key == "some updated private_key"
      assert address.public_key == "some updated public_key"
      assert address.remark == "some updated remark"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Wallet.update_address(address, @invalid_attrs)
      assert address == Wallet.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Wallet.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Wallet.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Wallet.change_address(address)
    end
  end
end
