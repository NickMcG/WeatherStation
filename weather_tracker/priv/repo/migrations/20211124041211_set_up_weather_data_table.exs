defmodule WeatherTracker.Repo.Migrations.SetUpWeatherDataTable do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb")

    create table(:weather_conditions, primary_key: false) do
      add :timestamp, :naive_datetime, null: false
      add :temperature_c, :decimal, null: false
      add :temperature_f, :decimal, null: false
      add :relative_humidity, :decimal, null: false
    end

    execute("SELECT create_hypertable('weather_conditions', 'timestamp')")
  end

  def down do
    drop table(:weather_conditions)
    execute("DROP EXTENSION IF EXISTS timescaledb")
  end
end
