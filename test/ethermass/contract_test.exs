defmodule Ethermass.ContractTest do
  use Ethermass.DataCase

  alias Ethermass.Contract

  describe "smart_contracts" do
    alias Ethermass.Contract.SmartContract

    import Ethermass.ContractFixtures

    @invalid_attrs %{abi: nil, label: nil, metadata: nil, network: nil, type: nil}

    test "list_smart_contracts/0 returns all smart_contracts" do
      smart_contract = smart_contract_fixture()
      assert Contract.list_smart_contracts() == [smart_contract]
    end

    test "get_smart_contract!/1 returns the smart_contract with given id" do
      smart_contract = smart_contract_fixture()
      assert Contract.get_smart_contract!(smart_contract.id) == smart_contract
    end

    test "create_smart_contract/1 with valid data creates a smart_contract" do
      valid_attrs = %{abi: "some abi", label: "some label", metadata: "some metadata", network: "some network", type: "some type"}

      assert {:ok, %SmartContract{} = smart_contract} = Contract.create_smart_contract(valid_attrs)
      assert smart_contract.abi == "some abi"
      assert smart_contract.label == "some label"
      assert smart_contract.metadata == "some metadata"
      assert smart_contract.network == "some network"
      assert smart_contract.type == "some type"
    end

    test "create_smart_contract/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Contract.create_smart_contract(@invalid_attrs)
    end

    test "update_smart_contract/2 with valid data updates the smart_contract" do
      smart_contract = smart_contract_fixture()
      update_attrs = %{abi: "some updated abi", label: "some updated label", metadata: "some updated metadata", network: "some updated network", type: "some updated type"}

      assert {:ok, %SmartContract{} = smart_contract} = Contract.update_smart_contract(smart_contract, update_attrs)
      assert smart_contract.abi == "some updated abi"
      assert smart_contract.label == "some updated label"
      assert smart_contract.metadata == "some updated metadata"
      assert smart_contract.network == "some updated network"
      assert smart_contract.type == "some updated type"
    end

    test "update_smart_contract/2 with invalid data returns error changeset" do
      smart_contract = smart_contract_fixture()
      assert {:error, %Ecto.Changeset{}} = Contract.update_smart_contract(smart_contract, @invalid_attrs)
      assert smart_contract == Contract.get_smart_contract!(smart_contract.id)
    end

    test "delete_smart_contract/1 deletes the smart_contract" do
      smart_contract = smart_contract_fixture()
      assert {:ok, %SmartContract{}} = Contract.delete_smart_contract(smart_contract)
      assert_raise Ecto.NoResultsError, fn -> Contract.get_smart_contract!(smart_contract.id) end
    end

    test "change_smart_contract/1 returns a smart_contract changeset" do
      smart_contract = smart_contract_fixture()
      assert %Ecto.Changeset{} = Contract.change_smart_contract(smart_contract)
    end
  end
end
