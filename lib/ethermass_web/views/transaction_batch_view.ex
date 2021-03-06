defmodule EthermassWeb.TransactionBatchView do
  use EthermassWeb, :view

  def truncate_address(address) do
    String.slice(address, 0,6) <> "..." <> String.slice(address, -4, 4)
  end

  def get_target_address(arguments) do
    arguments |> String.split(",") |> List.first() |> String.replace("[", "")
  end
end
