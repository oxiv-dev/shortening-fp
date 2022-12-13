defmodule Shorten.Repo do
  use Ecto.Repo,
    otp_app: :shorten,
    adapter: Ecto.Adapters.Postgres
end
