defmodule Ethermass.MonitoringTest do
  use Ethermass.DataCase

  alias Ethermass.Monitoring

  describe "owner_list" do
    alias Ethermass.Monitoring.OwnerList

    import Ethermass.MonitoringFixtures

    @invalid_attrs %{address: nil, last_check: nil, remark: nil, token_id: nil, token_type: nil}

    test "list_owner_list/0 returns all owner_list" do
      owner_list = owner_list_fixture()
      assert Monitoring.list_owner_list() == [owner_list]
    end

    test "get_owner_list!/1 returns the owner_list with given id" do
      owner_list = owner_list_fixture()
      assert Monitoring.get_owner_list!(owner_list.id) == owner_list
    end

    test "create_owner_list/1 with valid data creates a owner_list" do
      valid_attrs = %{address: "some address", last_check: ~N[2022-01-29 06:48:00], remark: "some remark", token_id: 42, token_type: "some token_type"}

      assert {:ok, %OwnerList{} = owner_list} = Monitoring.create_owner_list(valid_attrs)
      assert owner_list.address == "some address"
      assert owner_list.last_check == ~N[2022-01-29 06:48:00]
      assert owner_list.remark == "some remark"
      assert owner_list.token_id == 42
      assert owner_list.token_type == "some token_type"
    end

    test "create_owner_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_owner_list(@invalid_attrs)
    end

    test "update_owner_list/2 with valid data updates the owner_list" do
      owner_list = owner_list_fixture()
      update_attrs = %{address: "some updated address", last_check: ~N[2022-01-30 06:48:00], remark: "some updated remark", token_id: 43, token_type: "some updated token_type"}

      assert {:ok, %OwnerList{} = owner_list} = Monitoring.update_owner_list(owner_list, update_attrs)
      assert owner_list.address == "some updated address"
      assert owner_list.last_check == ~N[2022-01-30 06:48:00]
      assert owner_list.remark == "some updated remark"
      assert owner_list.token_id == 43
      assert owner_list.token_type == "some updated token_type"
    end

    test "update_owner_list/2 with invalid data returns error changeset" do
      owner_list = owner_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitoring.update_owner_list(owner_list, @invalid_attrs)
      assert owner_list == Monitoring.get_owner_list!(owner_list.id)
    end

    test "delete_owner_list/1 deletes the owner_list" do
      owner_list = owner_list_fixture()
      assert {:ok, %OwnerList{}} = Monitoring.delete_owner_list(owner_list)
      assert_raise Ecto.NoResultsError, fn -> Monitoring.get_owner_list!(owner_list.id) end
    end

    test "change_owner_list/1 returns a owner_list changeset" do
      owner_list = owner_list_fixture()
      assert %Ecto.Changeset{} = Monitoring.change_owner_list(owner_list)
    end
  end

  describe "market_maker" do
    alias Ethermass.Monitoring.MarketMaker

    import Ethermass.MonitoringFixtures

    @invalid_attrs %{address: nil, eth_balance: nil, group: nil, last_check: nil, nft_balance: nil}

    test "list_market_maker/0 returns all market_maker" do
      market_maker = market_maker_fixture()
      assert Monitoring.list_market_maker() == [market_maker]
    end

    test "get_market_maker!/1 returns the market_maker with given id" do
      market_maker = market_maker_fixture()
      assert Monitoring.get_market_maker!(market_maker.id) == market_maker
    end

    test "create_market_maker/1 with valid data creates a market_maker" do
      valid_attrs = %{address: "some address", eth_balance: 120.5, group: "some group", last_check: ~N[2022-01-30 09:27:00], nft_balance: 42}

      assert {:ok, %MarketMaker{} = market_maker} = Monitoring.create_market_maker(valid_attrs)
      assert market_maker.address == "some address"
      assert market_maker.eth_balance == 120.5
      assert market_maker.group == "some group"
      assert market_maker.last_check == ~N[2022-01-30 09:27:00]
      assert market_maker.nft_balance == 42
    end

    test "create_market_maker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Monitoring.create_market_maker(@invalid_attrs)
    end

    test "update_market_maker/2 with valid data updates the market_maker" do
      market_maker = market_maker_fixture()
      update_attrs = %{address: "some updated address", eth_balance: 456.7, group: "some updated group", last_check: ~N[2022-01-31 09:27:00], nft_balance: 43}

      assert {:ok, %MarketMaker{} = market_maker} = Monitoring.update_market_maker(market_maker, update_attrs)
      assert market_maker.address == "some updated address"
      assert market_maker.eth_balance == 456.7
      assert market_maker.group == "some updated group"
      assert market_maker.last_check == ~N[2022-01-31 09:27:00]
      assert market_maker.nft_balance == 43
    end

    test "update_market_maker/2 with invalid data returns error changeset" do
      market_maker = market_maker_fixture()
      assert {:error, %Ecto.Changeset{}} = Monitoring.update_market_maker(market_maker, @invalid_attrs)
      assert market_maker == Monitoring.get_market_maker!(market_maker.id)
    end

    test "delete_market_maker/1 deletes the market_maker" do
      market_maker = market_maker_fixture()
      assert {:ok, %MarketMaker{}} = Monitoring.delete_market_maker(market_maker)
      assert_raise Ecto.NoResultsError, fn -> Monitoring.get_market_maker!(market_maker.id) end
    end

    test "change_market_maker/1 returns a market_maker changeset" do
      market_maker = market_maker_fixture()
      assert %Ecto.Changeset{} = Monitoring.change_market_maker(market_maker)
    end
  end
end
