defmodule EthermassWeb.OwnerListController do
  use EthermassWeb, :controller

  alias Ethermass.Monitoring
  alias Ethermass.Monitoring.OwnerList

  def index(conn, _params) do
    owner_list = Monitoring.list_owner_list()
    render(conn, "index.html", owner_list: owner_list)
  end

  def new(conn, _params) do
    changeset = Monitoring.change_owner_list(%OwnerList{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"owner_list" => owner_list_params}) do
    case Monitoring.create_owner_list(owner_list_params) do
      {:ok, owner_list} ->
        conn
        |> put_flash(:info, "Owner list created successfully.")
        |> redirect(to: Routes.owner_list_path(conn, :show, owner_list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    owner_list = Monitoring.get_owner_list!(id)
    render(conn, "show.html", owner_list: owner_list)
  end

  def edit(conn, %{"id" => id}) do
    owner_list = Monitoring.get_owner_list!(id)
    changeset = Monitoring.change_owner_list(owner_list)
    render(conn, "edit.html", owner_list: owner_list, changeset: changeset)
  end

  def update(conn, %{"id" => id, "owner_list" => owner_list_params}) do
    owner_list = Monitoring.get_owner_list!(id)

    case Monitoring.update_owner_list(owner_list, owner_list_params) do
      {:ok, owner_list} ->
        conn
        |> put_flash(:info, "Owner list updated successfully.")
        |> redirect(to: Routes.owner_list_path(conn, :show, owner_list))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", owner_list: owner_list, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    owner_list = Monitoring.get_owner_list!(id)
    {:ok, _owner_list} = Monitoring.delete_owner_list(owner_list)

    conn
    |> put_flash(:info, "Owner list deleted successfully.")
    |> redirect(to: Routes.owner_list_path(conn, :index))
  end
end
