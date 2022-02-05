defmodule EthermassWeb.OwnerListControllerTest do
  use EthermassWeb.ConnCase

  import Ethermass.MonitoringFixtures

  @create_attrs %{address: "some address", last_check: ~N[2022-01-29 06:48:00], remark: "some remark", token_id: 42, token_type: "some token_type"}
  @update_attrs %{address: "some updated address", last_check: ~N[2022-01-30 06:48:00], remark: "some updated remark", token_id: 43, token_type: "some updated token_type"}
  @invalid_attrs %{address: nil, last_check: nil, remark: nil, token_id: nil, token_type: nil}

  describe "index" do
    test "lists all owner_list", %{conn: conn} do
      conn = get(conn, Routes.owner_list_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Owner list"
    end
  end

  describe "new owner_list" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.owner_list_path(conn, :new))
      assert html_response(conn, 200) =~ "New Owner list"
    end
  end

  describe "create owner_list" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.owner_list_path(conn, :create), owner_list: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.owner_list_path(conn, :show, id)

      conn = get(conn, Routes.owner_list_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Owner list"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.owner_list_path(conn, :create), owner_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Owner list"
    end
  end

  describe "edit owner_list" do
    setup [:create_owner_list]

    test "renders form for editing chosen owner_list", %{conn: conn, owner_list: owner_list} do
      conn = get(conn, Routes.owner_list_path(conn, :edit, owner_list))
      assert html_response(conn, 200) =~ "Edit Owner list"
    end
  end

  describe "update owner_list" do
    setup [:create_owner_list]

    test "redirects when data is valid", %{conn: conn, owner_list: owner_list} do
      conn = put(conn, Routes.owner_list_path(conn, :update, owner_list), owner_list: @update_attrs)
      assert redirected_to(conn) == Routes.owner_list_path(conn, :show, owner_list)

      conn = get(conn, Routes.owner_list_path(conn, :show, owner_list))
      assert html_response(conn, 200) =~ "some updated address"
    end

    test "renders errors when data is invalid", %{conn: conn, owner_list: owner_list} do
      conn = put(conn, Routes.owner_list_path(conn, :update, owner_list), owner_list: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Owner list"
    end
  end

  describe "delete owner_list" do
    setup [:create_owner_list]

    test "deletes chosen owner_list", %{conn: conn, owner_list: owner_list} do
      conn = delete(conn, Routes.owner_list_path(conn, :delete, owner_list))
      assert redirected_to(conn) == Routes.owner_list_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.owner_list_path(conn, :show, owner_list))
      end
    end
  end

  defp create_owner_list(_) do
    owner_list = owner_list_fixture()
    %{owner_list: owner_list}
  end
end
