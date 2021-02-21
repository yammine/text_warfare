# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :text_warfare,
  ecto_repos: [TextWarfare.Repo]

# Configures the endpoint
config :text_warfare, TextWarfareWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S0j6Q3NewTpdcaLVvlnEMrRmajVYWmPN3MmrUS2fWO6RGYM6OPM1h60MZsQonDEy",
  render_errors: [view: TextWarfareWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TextWarfare.PubSub,
  live_view: [signing_salt: "c7WJbkVO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
