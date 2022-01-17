defmodule EthermassWeb.TransactionBatchController do
  use EthermassWeb, :controller

  alias Ethermass.Transaction
  alias Ethermass.Transaction.TransactionBatch

  def index(conn, _params) do
    transaction_batch = Transaction.list_transaction_batch()
    render(conn, "index.html", transaction_batch: transaction_batch)
  end

  def new(conn, _params) do
    changeset = Transaction.change_transaction_batch(%TransactionBatch{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"transaction_batch" => transaction_batch_params}) do
    case Transaction.create_transaction_batch(transaction_batch_params) do
      {:ok, transaction_batch} ->
        conn
        |> put_flash(:info, "Transaction batch created successfully.")
        |> redirect(to: Routes.transaction_batch_path(conn, :show, transaction_batch))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction_batch = Transaction.get_transaction_batch!(id) |> IO.inspect()
    render(conn, "show.html", transaction_batch: transaction_batch)
  end

  def edit(conn, %{"id" => id}) do
    transaction_batch = Transaction.get_transaction_batch!(id)
    changeset = Transaction.change_transaction_batch(transaction_batch)
    render(conn, "edit.html", transaction_batch: transaction_batch, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction_batch" => transaction_batch_params}) do
    transaction_batch = Transaction.get_transaction_batch!(id)

    case Transaction.update_transaction_batch(transaction_batch, transaction_batch_params) do
      {:ok, transaction_batch} ->
        conn
        |> put_flash(:info, "Transaction batch updated successfully.")
        |> redirect(to: Routes.transaction_batch_path(conn, :show, transaction_batch))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction_batch: transaction_batch, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction_batch = Transaction.get_transaction_batch!(id)
    {:ok, _transaction_batch} = Transaction.delete_transaction_batch(transaction_batch)

    conn
    |> put_flash(:info, "Transaction batch deleted successfully.")
    |> redirect(to: Routes.transaction_batch_path(conn, :index))
  end
end
