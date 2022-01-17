defmodule EthermassWeb.SmartContractController do
  use EthermassWeb, :controller

  alias Ethermass.Contract
  alias Ethermass.Contract.SmartContract

  def index(conn, _params) do
    smart_contracts = Contract.list_smart_contracts()
    render(conn, "index.html", smart_contracts: smart_contracts)
  end

  def new(conn, _params) do
    changeset = Contract.change_smart_contract(%SmartContract{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"smart_contract" => smart_contract_params}) do
    case Contract.create_smart_contract(smart_contract_params) do
      {:ok, smart_contract} ->
        conn
        |> put_flash(:info, "Smart contract created successfully.")
        |> redirect(to: Routes.smart_contract_path(conn, :show, smart_contract))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    smart_contract = Contract.get_smart_contract!(id)
    render(conn, "show.html", smart_contract: smart_contract)
  end

  def edit(conn, %{"id" => id}) do
    smart_contract = Contract.get_smart_contract!(id)
    changeset = Contract.change_smart_contract(smart_contract)
    render(conn, "edit.html", smart_contract: smart_contract, changeset: changeset)
  end

  def update(conn, %{"id" => id, "smart_contract" => smart_contract_params}) do
    smart_contract = Contract.get_smart_contract!(id)

    case Contract.update_smart_contract(smart_contract, smart_contract_params) do
      {:ok, smart_contract} ->
        conn
        |> put_flash(:info, "Smart contract updated successfully.")
        |> redirect(to: Routes.smart_contract_path(conn, :show, smart_contract))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", smart_contract: smart_contract, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    smart_contract = Contract.get_smart_contract!(id)
    {:ok, _smart_contract} = Contract.delete_smart_contract(smart_contract)

    conn
    |> put_flash(:info, "Smart contract deleted successfully.")
    |> redirect(to: Routes.smart_contract_path(conn, :index))
  end
end
