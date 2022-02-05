defmodule EthermassWeb.MarketMakerController do
  use EthermassWeb, :controller

  alias Ethermass.Monitoring
  alias Ethermass.Monitoring.MarketMaker

  def index(conn, _params) do
    market_maker = Monitoring.list_market_maker()
    render(conn, "index.html", market_maker: market_maker)
  end

  def new(conn, _params) do
    changeset = Monitoring.change_market_maker(%MarketMaker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"market_maker" => market_maker_params}) do
    case Monitoring.create_market_maker(market_maker_params) do
      {:ok, market_maker} ->
        conn
        |> put_flash(:info, "Market maker created successfully.")
        |> redirect(to: Routes.market_maker_path(conn, :show, market_maker))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    market_maker = Monitoring.get_market_maker!(id)
    render(conn, "show.html", market_maker: market_maker)
  end

  def edit(conn, %{"id" => id}) do
    market_maker = Monitoring.get_market_maker!(id)
    changeset = Monitoring.change_market_maker(market_maker)
    render(conn, "edit.html", market_maker: market_maker, changeset: changeset)
  end

  def update(conn, %{"id" => id, "market_maker" => market_maker_params}) do
    market_maker = Monitoring.get_market_maker!(id)

    case Monitoring.update_market_maker(market_maker, market_maker_params) do
      {:ok, market_maker} ->
        conn
        |> put_flash(:info, "Market maker updated successfully.")
        |> redirect(to: Routes.market_maker_path(conn, :show, market_maker))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", market_maker: market_maker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    market_maker = Monitoring.get_market_maker!(id)
    {:ok, _market_maker} = Monitoring.delete_market_maker(market_maker)

    conn
    |> put_flash(:info, "Market maker deleted successfully.")
    |> redirect(to: Routes.market_maker_path(conn, :index))
  end
end
