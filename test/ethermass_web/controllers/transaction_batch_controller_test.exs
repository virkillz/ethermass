defmodule EthermassWeb.TransactionBatchControllerTest do
  use EthermassWeb.ConnCase

  import Ethermass.TransactionFixtures

  @create_attrs %{gas_limit: 42, gas_price: 42, network: "some network", title: "some title", to: "some to", type: "some type", value: 120.5}
  @update_attrs %{gas_limit: 43, gas_price: 43, network: "some updated network", title: "some updated title", to: "some updated to", type: "some updated type", value: 456.7}
  @invalid_attrs %{gas_limit: nil, gas_price: nil, network: nil, title: nil, to: nil, type: nil, value: nil}

  describe "index" do
    test "lists all transaction_batch", %{conn: conn} do
      conn = get(conn, Routes.transaction_batch_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transaction batch"
    end
  end

  describe "new transaction_batch" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transaction_batch_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transaction batch"
    end
  end

  describe "create transaction_batch" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transaction_batch_path(conn, :create), transaction_batch: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transaction_batch_path(conn, :show, id)

      conn = get(conn, Routes.transaction_batch_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transaction batch"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_batch_path(conn, :create), transaction_batch: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transaction batch"
    end
  end

  describe "edit transaction_batch" do
    setup [:create_transaction_batch]

    test "renders form for editing chosen transaction_batch", %{conn: conn, transaction_batch: transaction_batch} do
      conn = get(conn, Routes.transaction_batch_path(conn, :edit, transaction_batch))
      assert html_response(conn, 200) =~ "Edit Transaction batch"
    end
  end

  describe "update transaction_batch" do
    setup [:create_transaction_batch]

    test "redirects when data is valid", %{conn: conn, transaction_batch: transaction_batch} do
      conn = put(conn, Routes.transaction_batch_path(conn, :update, transaction_batch), transaction_batch: @update_attrs)
      assert redirected_to(conn) == Routes.transaction_batch_path(conn, :show, transaction_batch)

      conn = get(conn, Routes.transaction_batch_path(conn, :show, transaction_batch))
      assert html_response(conn, 200) =~ "some updated network"
    end

    test "renders errors when data is invalid", %{conn: conn, transaction_batch: transaction_batch} do
      conn = put(conn, Routes.transaction_batch_path(conn, :update, transaction_batch), transaction_batch: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Transaction batch"
    end
  end

  describe "delete transaction_batch" do
    setup [:create_transaction_batch]

    test "deletes chosen transaction_batch", %{conn: conn, transaction_batch: transaction_batch} do
      conn = delete(conn, Routes.transaction_batch_path(conn, :delete, transaction_batch))
      assert redirected_to(conn) == Routes.transaction_batch_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_batch_path(conn, :show, transaction_batch))
      end
    end
  end

  defp create_transaction_batch(_) do
    transaction_batch = transaction_batch_fixture()
    %{transaction_batch: transaction_batch}
  end
end
