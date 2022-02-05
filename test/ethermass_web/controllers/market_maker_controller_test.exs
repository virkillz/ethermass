defmodule EthermassWeb.MarketMakerControllerTest do
  use EthermassWeb.ConnCase

  import Ethermass.MonitoringFixtures

  @create_attrs %{address: "some address", eth_balance: 120.5, group: "some group", last_check: ~N[2022-01-30 09:27:00], nft_balance: 42}
  @update_attrs %{address: "some updated address", eth_balance: 456.7, group: "some updated group", last_check: ~N[2022-01-31 09:27:00], nft_balance: 43}
  @invalid_attrs %{address: nil, eth_balance: nil, group: nil, last_check: nil, nft_balance: nil}

  describe "index" do
    test "lists all market_maker", %{conn: conn} do
      conn = get(conn, Routes.market_maker_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Market maker"
    end
  end

  describe "new market_maker" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.market_maker_path(conn, :new))
      assert html_response(conn, 200) =~ "New Market maker"
    end
  end

  describe "create market_maker" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.market_maker_path(conn, :create), market_maker: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.market_maker_path(conn, :show, id)

      conn = get(conn, Routes.market_maker_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Market maker"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.market_maker_path(conn, :create), market_maker: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Market maker"
    end
  end

  describe "edit market_maker" do
    setup [:create_market_maker]

    test "renders form for editing chosen market_maker", %{conn: conn, market_maker: market_maker} do
      conn = get(conn, Routes.market_maker_path(conn, :edit, market_maker))
      assert html_response(conn, 200) =~ "Edit Market maker"
    end
  end

  describe "update market_maker" do
    setup [:create_market_maker]

    test "redirects when data is valid", %{conn: conn, market_maker: market_maker} do
      conn = put(conn, Routes.market_maker_path(conn, :update, market_maker), market_maker: @update_attrs)
      assert redirected_to(conn) == Routes.market_maker_path(conn, :show, market_maker)

      conn = get(conn, Routes.market_maker_path(conn, :show, market_maker))
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, market_maker: market_maker} do
      conn = put(conn, Routes.market_maker_path(conn, :update, market_maker), market_maker: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Market maker"
    end
  end

  describe "delete market_maker" do
    setup [:create_market_maker]

    test "deletes chosen market_maker", %{conn: conn, market_maker: market_maker} do
      conn = delete(conn, Routes.market_maker_path(conn, :delete, market_maker))
      assert redirected_to(conn) == Routes.market_maker_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.market_maker_path(conn, :show, market_maker))
      end
    end
  end

  defp create_market_maker(_) do
    market_maker = market_maker_fixture()
    %{market_maker: market_maker}
  end
end
