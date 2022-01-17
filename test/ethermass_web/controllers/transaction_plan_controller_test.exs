defmodule EthermassWeb.TransactionPlanControllerTest do
  use EthermassWeb.ConnCase

  import Ethermass.TransactionFixtures

  @create_attrs %{arguments: "some arguments", attempt: 42, from: "some from", function: "some function", gas_fee: 42, gas_limit: 42, gas_price: 42, hash: "some hash", network: "some network", remark: "some remark", status: "some status", title: "some title", to: "some to", transaction_type: "some transaction_type", value: 120.5}
  @update_attrs %{arguments: "some updated arguments", attempt: 43, from: "some updated from", function: "some updated function", gas_fee: 43, gas_limit: 43, gas_price: 43, hash: "some updated hash", network: "some updated network", remark: "some updated remark", status: "some updated status", title: "some updated title", to: "some updated to", transaction_type: "some updated transaction_type", value: 456.7}
  @invalid_attrs %{arguments: nil, attempt: nil, from: nil, function: nil, gas_fee: nil, gas_limit: nil, gas_price: nil, hash: nil, network: nil, remark: nil, status: nil, title: nil, to: nil, transaction_type: nil, value: nil}

  describe "index" do
    test "lists all transaction_plans", %{conn: conn} do
      conn = get(conn, Routes.transaction_plan_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transaction plans"
    end
  end

  describe "new transaction_plan" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transaction_plan_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transaction plan"
    end
  end

  describe "create transaction_plan" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_plan_path(conn, :create), transaction_plan: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transaction_plan_path(conn, :show, id)

      conn = get(conn, Routes.transaction_plan_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transaction plan"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_plan_path(conn, :create), transaction_plan: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transaction plan"
    end
  end

  describe "edit transaction_plan" do
    setup [:create_transaction_plan]

    test "renders form for editing chosen transaction_plan", %{conn: conn, transaction_plan: transaction_plan} do
      conn = get(conn, Routes.transaction_plan_path(conn, :edit, transaction_plan))
      assert html_response(conn, 200) =~ "Edit Transaction plan"
    end
  end

  describe "update transaction_plan" do
    setup [:create_transaction_plan]

    test "redirects when data is valid", %{conn: conn, transaction_plan: transaction_plan} do
      conn = put(conn, Routes.transaction_plan_path(conn, :update, transaction_plan), transaction_plan: @update_attrs)
      assert redirected_to(conn) == Routes.transaction_plan_path(conn, :show, transaction_plan)

      conn = get(conn, Routes.transaction_plan_path(conn, :show, transaction_plan))
      assert html_response(conn, 200) =~ "some updated arguments"
    end

    test "renders errors when data is invalid", %{conn: conn, transaction_plan: transaction_plan} do
      conn = put(conn, Routes.transaction_plan_path(conn, :update, transaction_plan), transaction_plan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Transaction plan"
    end
  end

  describe "delete transaction_plan" do
    setup [:create_transaction_plan]

    test "deletes chosen transaction_plan", %{conn: conn, transaction_plan: transaction_plan} do
      conn = delete(conn, Routes.transaction_plan_path(conn, :delete, transaction_plan))
      assert redirected_to(conn) == Routes.transaction_plan_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_plan_path(conn, :show, transaction_plan))
      end
    end
  end

  defp create_transaction_plan(_) do
    transaction_plan = transaction_plan_fixture()
    %{transaction_plan: transaction_plan}
  end
end
