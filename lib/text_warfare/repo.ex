defmodule TextWarfare.Repo do
  use Ecto.Repo,
    otp_app: :text_warfare,
    adapter: Ecto.Adapters.Postgres
end
