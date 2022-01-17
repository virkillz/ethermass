defmodule EthermassWeb.SmartContractControllerTest do
  use EthermassWeb.ConnCase

  import Ethermass.ContractFixtures

  @create_attrs %{abi: "some abi", label: "some label", metadata: "some metadata", network: "some network", type: "some type"}
  @update_attrs %{abi: "some updated abi", label: "some updated label", metadata: "some updated metadata", network: "some updated network", type: "some updated type"}
  @invalid_attrs %{abi: nil, label: nil, metadata: nil, network: nil, type: nil}

  describe "index" do
    test "lists all smart_contracts", %{conn: conn} do
      conn = get(conn, Routes.smart_contract_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Smart contracts"
    end
  end

  describe "new smart_contract" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.smart_contract_path(conn, :new))
      assert html_response(conn, 200) =~ "New Smart contract"
    end
  end

  describe "create smart_contract" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.smart_contract_path(conn, :create), smart_contract: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.smart_contract_path(conn, :show, id)

      conn = get(conn, Routes.smart_contract_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Smart contract"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.smart_contract_path(conn, :create), smart_contract: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Smart contract"
    end
  end

  describe "edit smart_contract" do
    setup [:create_smart_contract]

    test "renders form for editing chosen smart_contract", %{conn: conn, smart_contract: smart_contract} do
      conn = get(conn, Routes.smart_contract_path(conn, :edit, smart_contract))
      assert html_response(conn, 200) =~ "Edit Smart contract"
    end
  end

  describe "update smart_contract" do
    setup [:create_smart_contract]

    test "redirects when data is valid", %{conn: conn, smart_contract: smart_contract} do
      conn = put(conn, Routes.smart_contract_path(conn, :update, smart_contract), smart_contract: @update_attrs)
      assert redirected_to(conn) == Routes.smart_contract_path(conn, :show, smart_contract)

      conn = get(conn, Routes.smart_contract_path(conn, :show, smart_contract))
      assert html_response(conn, 200) =~ "some updated abi"
    end

    test "renders errors when data is invalid", %{conn: conn, smart_contract: smart_contract} do
      conn = put(conn, Routes.smart_contract_path(conn, :update, smart_contract), smart_contract: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Smart contract"
    end
  end

  describe "delete smart_contract" do
    setup [:create_smart_contract]

    test "deletes chosen smart_contract", %{conn: conn, smart_contract: smart_contract} do
      conn = delete(conn, Routes.smart_contract_path(conn, :delete, smart_contract))
      assert redirected_to(conn) == Routes.smart_contract_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.smart_contract_path(conn, :show, smart_contract))
      end
    end
  end

  defp create_smart_contract(_) do
    smart_contract = smart_contract_fixture()
    %{smart_contract: smart_contract}
  end
end
