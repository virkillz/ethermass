defmodule Ethermass.Repo do
  use Ecto.Repo,
    otp_app: :ethermass,
    adapter: Ecto.Adapters.Postgres
end
