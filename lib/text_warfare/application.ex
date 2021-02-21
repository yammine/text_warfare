defmodule TextWarfare.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    unless Mix.env() == :prod do
      Envy.auto_load()
      # This is usually run before starting any applications, so we have to manually reload config
      Mix.Task.run("loadconfig")
    end

    children = [
      # Start the Ecto repository
      TextWarfare.Repo,
      # Start the Telemetry supervisor
      TextWarfareWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TextWarfare.PubSub},
      # Start the Endpoint (http/https)
      TextWarfareWeb.Endpoint
      # Start a worker by calling: TextWarfare.Worker.start_link(arg)
      # {TextWarfare.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TextWarfare.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TextWarfareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
