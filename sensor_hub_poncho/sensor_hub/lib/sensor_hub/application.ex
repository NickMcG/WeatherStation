defmodule SensorHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias SensorHub.Sensor
  require Logger

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    Logger.debug("Testing...")
    opts = [strategy: :one_for_one, name: SensorHub.Supervisor]
    children = children(target())
    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Children that only run on the host
      # Starts a worker by calling: SensorHub.Worker.start_link(arg)
      # {SensorHub.Worker, arg},
    ]
  end

  def children(_target) do
    # The sensors will fail on the host so let's only start them on the target devices.
    [
      {SHTC3, %{}},
      {Finch, name: WeatherTrackerClient},
      {
        Publisher,
        %{
          sensors: sensors(),
          weather_tracker_url: weather_tracker_url()
        }
      }
    ]
  end

  def target() do
    Application.get_env(:sensor_hub, :target)
  end

  def sensors() do
    [Sensor.new(SHTC3)]
  end

  def weather_tracker_url do
    Application.get_env(:sensor_hub, :weather_tracker_url)
  end
end
