defmodule EthermassWeb.TransactionPlanController do
  use EthermassWeb, :controller

  alias Ethermass.Transaction
  alias Ethermass.Transaction.TransactionPlan

  def index(conn, _params) do
    transaction_plans = Transaction.list_transaction_plans()
    render(conn, "index.html", transaction_plans: transaction_plans)
  end

  def run_plan(conn, %{"id" => id}) do
    transaction_plan = Transaction.get_transaction_plan!(id)
    case Transaction.run_transaction_plan(transaction_plan) do
      {:ok, new_transaction_plan} ->
        conn
        |> put_flash(:info, "Run successfully")
        |> redirect(to: Routes.transaction_plan_path(conn, :show, new_transaction_plan))
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.transaction_plan_path(conn, :show, transaction_plan))
    end
    # text(conn, "ok")
  end

  def new(conn, _params) do
    changeset = Transaction.change_transaction_plan(%TransactionPlan{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transaction_plan" => transaction_plan_params}) do
    case Transaction.create_transaction_plan(transaction_plan_params) do
      {:ok, transaction_plan} ->
        conn
        |> put_flash(:info, "Transaction plan created successfully.")
        |> redirect(to: Routes.transaction_plan_path(conn, :show, transaction_plan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction_plan = Transaction.get_transaction_plan!(id)
    render(conn, "show.html", transaction_plan: transaction_plan)
  end

  def edit(conn, %{"id" => id}) do
    transaction_plan = Transaction.get_transaction_plan!(id)
    changeset = Transaction.change_transaction_plan(transaction_plan)
    render(conn, "edit.html", transaction_plan: transaction_plan, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction_plan" => transaction_plan_params}) do
    transaction_plan = Transaction.get_transaction_plan!(id)

    case Transaction.update_transaction_plan(transaction_plan, transaction_plan_params) do
      {:ok, transaction_plan} ->
        conn
        |> put_flash(:info, "Transaction plan updated successfully.")
        |> redirect(to: Routes.transaction_plan_path(conn, :show, transaction_plan))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction_plan: transaction_plan, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction_plan = Transaction.get_transaction_plan!(id)
    {:ok, _transaction_plan} = Transaction.delete_transaction_plan(transaction_plan)

    conn
    |> put_flash(:info, "Transaction plan deleted successfully.")
    |> redirect(to: Routes.transaction_plan_path(conn, :index))
  end
end
