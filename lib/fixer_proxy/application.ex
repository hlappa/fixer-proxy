defmodule FixerProxy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: FixerProxy.PubSub},
      # Start the Endpoint (http/https)
      FixerProxyWeb.Endpoint,
      # Start a worker by calling: FixerProxy.Worker.start_link(arg)
      # {FixerProxy.Worker, arg}
      Fixer.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FixerProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FixerProxyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
