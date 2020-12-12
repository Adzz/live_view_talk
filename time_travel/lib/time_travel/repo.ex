defmodule TimeTravel.Repo do
  use Ecto.Repo,
    otp_app: :time_travel,
    adapter: Ecto.Adapters.Postgres
end
