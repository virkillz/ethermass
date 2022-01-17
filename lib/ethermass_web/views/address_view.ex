defmodule EthermassWeb.AddressView do
  use EthermassWeb, :view


  def truncate_address(address) do
    String.slice(address, 0,6) <> "..." <> String.slice(address, -4, 4)
  end
end
