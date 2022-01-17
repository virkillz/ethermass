defmodule Ethermass.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ethermass.Repo,
      # Start the Telemetry supervisor
      EthermassWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ethermass.PubSub},
      # Start the Endpoint (http/https)
      EthermassWeb.Endpoint
      # Start a worker by calling: Ethermass.Worker.start_link(arg)
      # {Ethermass.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ethermass.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EthermassWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
