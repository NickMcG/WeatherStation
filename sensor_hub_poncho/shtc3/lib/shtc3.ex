defmodule SHTC3 do
  use GenServer
  require Logger
  alias SHTC3.Comm

  @impl true
  def init(%{address: address, i2c_bus_name: bus_name}) do
    i2c = Comm.open(bus_name)

    :timer.send_interval(1_000, :measure)
    state = %{
      i2c: i2c,
      address: address,
      last_reading: :no_reading
    }
    {:ok, state}
  end

  def init(%{}) do
    {bus_name, address} = Comm.discover()
    transport = "bus: #{bus_name}, address: #{address}"
    Logger.info("Starting SHTC3. Please specify an address and a bus.")
    Logger.info("Starting on " <> transport)
    init(%{address: address, i2c_bus_name: bus_name})
  end

  @impl true
  def handle_info(:measure, %{i2c: i2c, address: address} = state) do
    last_reading = Comm.read(i2c, address, false, true)
    updated_with_reading = %{state | last_reading: last_reading}
    {:noreply, updated_with_reading}
  end

  @impl true
  def handle_call(:get_measurement, _from, state), do: {:reply, state.last_reading, state}

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  def get_measurement() do
    GenServer.call(__MODULE__, :get_measurement)
  end
end
