use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :time_travel, TimeTravel.Repo,
  username: "postgres",
  password: "postgres",
  database: "time_travel_test",
  hostname: "localhost",
  pool_size: 10,
  port: 54321,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_timestamps: [type: :utc_datetime],
  # Super long timeout to avoid interrupting pry sessions
  ownership_timeout: 999_999_999,
  # see here https://hexdocs.pm/db_connection/DBConnection.html#start_link/2-queue-config
  queue_target: 5_000,
  queue_interval: 10_000,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :time_travel, TimeTravelWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
