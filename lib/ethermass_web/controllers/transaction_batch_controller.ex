defmodule EthermassWeb.TransactionBatchController do
  use EthermassWeb, :controller

  alias Ethermass.Transaction
  alias Ethermass.Transaction.TransactionBatch

  def index(conn, _params) do
    transaction_batch = Transaction.list_transaction_batch()
    render(conn, "index.html", transaction_batch: transaction_batch)
  end

  def toggle_start(conn, %{"id" => id}) do
    transaction_batch = Transaction.get_transaction_batch!(id)

    case Transaction.toggle_transaction_batch(transaction_batch) do
      {:ok, _transaction_batch} ->
        transaction_batch = Transaction.list_transaction_batch()
        render(conn, "index.html", transaction_batch: transaction_batch)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction_batch: transaction_batch, changeset: changeset)

      {:error, reason} ->
        transaction_batch = Transaction.list_transaction_batch()

          conn
          |> put_flash(:error, reason)
          |> render("index.html", transaction_batch: transaction_batch)
    end
  end

  def new(conn, _params) do
    changeset = Transaction.change_transaction_batch(%TransactionBatch{})
    render(conn, "new.html", changeset: changeset)
  end

  def new_mass_funding(conn, _params) do
    changeset = Transaction.change_transaction_batch(%TransactionBatch{})
    render(conn, "new_mass_funding.html", changeset: changeset)
  end

  def new_mass_whitelist(conn, _params) do
    changeset = Transaction.change_transaction_batch(%TransactionBatch{})
    render(conn, "new_mass_whitelist.html", changeset: changeset)
  end

  def create_mass_whitelist(conn, %{"transaction_batch" => transaction_batch_params}) do
    IO.inspect(transaction_batch_params)
    case Transaction.create_transaction_batch_mass_whitelist(transaction_batch_params) do
      {:ok, _transaction_batch} ->
        conn
        |> put_flash(:info, "Transaction batch created successfully.")
        |> redirect(to: Routes.transaction_batch_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new_mass_whitelist.html", changeset: changeset)

      {:error, :transaction_batch, %Ecto.Changeset{} = changeset, _} ->
          render(conn, "new_mass_whitelist.html", changeset: changeset)
      error ->
          IO.inspect(error)
        text(conn, "Error. Check console.")
    end
  end

  def create_mass_funding(conn, %{"transaction_batch" => transaction_batch_params}) do
    IO.inspect(transaction_batch_params)
    case Transaction.create_transaction_batch_mass_funding(transaction_batch_params) do
      {:ok, _transaction_batch} ->
        conn
        |> put_flash(:info, "Transaction batch created successfully.")
        |> redirect(to: Routes.transaction_batch_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new_mass_funding.html", changeset: changeset)

      {:error, :transaction_batch, %Ecto.Changeset{} = changeset, _} ->
          render(conn, "new_mass_funding.html", changeset: changeset)
      error ->
          IO.inspect(error)
        text(conn, "Error. Check console.")
    end
  end


  def new_mass_minting(conn, _params) do
    changeset = Transaction.change_transaction_batch(%TransactionBatch{})
    render(conn, "new_mass_minting.html", changeset: changeset)
  end


  def create_mass_minting(conn, %{"transaction_batch" => transaction_batch_params}) do
    case Transaction.create_transaction_batch_mass_minting(transaction_batch_params) do
      {:ok, _transaction_batch} ->
        conn
        |> put_flash(:info, "Transaction batch created successfully.")
        |> redirect(to: Routes.transaction_batch_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new_mass_minting.html", changeset: changeset)

      {:error, :transaction_batch, %Ecto.Changeset{} = changeset, _} ->
          render(conn, "new_mass_minting.html", changeset: changeset)
      error ->
        text(conn, "Error. Check console.")
    end
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
    transaction_batch = Transaction.get_transaction_batch!(id)

    summary = Ethermass.Transaction.get_status_summary(2)

    case transaction_batch.type do
      "nft_whitelisting" ->
        render(conn, "show_batch_whitelist.html", transaction_batch: transaction_batch, summary: summary)
      _other -> render(conn, "show.html", transaction_batch: transaction_batch)
    end


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
