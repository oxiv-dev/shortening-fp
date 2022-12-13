defmodule Shorten.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      # Shorten.Repo,
      # Start the Telemetry supervisor
      ShortenWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Shorten.PubSub},
      # Start the Endpoint (http/https)
      ShortenWeb.Endpoint
      # Start a worker by calling: Shorten.Worker.start_link(arg)
      # {Shorten.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shorten.Supervisor]
    :ets.new(:links, [:public, :set, :named_table])
    :ets.new(:ids, [:public, :set, :named_table])

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShortenWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
