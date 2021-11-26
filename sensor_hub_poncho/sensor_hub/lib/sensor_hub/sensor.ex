defmodule SensorHub.Sensor do
  defstruct [:name, :fields, :read, :convert]

  def new(name) do
    %__MODULE__{
      read: read_fn(name),
      convert: convert_fn(name),
      fields: fields(name),
      name: name
    }
  end

  def fields(SHTC3), do: [:temperature_c, :temperature_f, :relative_humidity]

  def read_fn(SHTC3), do: fn -> SHTC3.get_measurement() end

  def convert_fn(SHTC3) do
    fn data -> data end
  end
end
