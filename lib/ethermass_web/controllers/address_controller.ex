defmodule EthermassWeb.AddressController do
  use EthermassWeb, :controller

  alias Ethermass.Wallet
  alias Ethermass.Wallet.Address

  def index(conn, _params) do
    addresses = Wallet.list_addresses()
    render(conn, "index.html", addresses: addresses)
  end

  def new(conn, _params) do
    changeset = Wallet.change_address(%Address{})
    render(conn, "import.html", changeset: changeset)
  end

  def generate_form(conn, _params) do
    changeset = Wallet.change_address(%Address{})
    render(conn, "generate.html", changeset: changeset)
  end

  def create(conn, %{"address" => address_params}) do
    case Wallet.import_address(address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address created successfully.")
        |> redirect(to: Routes.address_path(conn, :show, address))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "import.html", changeset: changeset)
    end
  end

  def generate_post(conn, %{"address" => address_params}) do
    case Wallet.generate_address(address_params) do
      {:ok, _address} ->
        conn
        |> put_flash(:info, "Address created successfully.")
        |> redirect(to: Routes.address_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "generate.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Wallet.get_address!(id) |> Wallet.update_eth_balance()

    render(conn, "show.html", address: address)
  end

  def edit(conn, %{"id" => id}) do
    address = Wallet.get_address!(id)
    changeset = Wallet.change_address(address)
    render(conn, "edit.html", address: address, changeset: changeset)
  end

  def update(conn, %{"id" => id, "address" => address_params}) do
    address = Wallet.get_address!(id)

    case Wallet.update_address(address, address_params) do
      {:ok, address} ->
        conn
        |> put_flash(:info, "Address updated successfully.")
        |> redirect(to: Routes.address_path(conn, :show, address))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", address: address, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Wallet.get_address!(id)
    {:ok, _address} = Wallet.delete_address(address)

    conn
    |> put_flash(:info, "Address deleted successfully.")
    |> redirect(to: Routes.address_path(conn, :index))
  end
end
