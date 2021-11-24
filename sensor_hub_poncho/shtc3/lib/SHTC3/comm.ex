defmodule SHTC3.Comm do
  alias Circuits.I2C
  alias SHTC3.Reading

  def discover(possible_addresses \\ [0x70]) do
    I2C.discover_one!(possible_addresses)
  end

  def open(bus_name) do
    {:ok, i2c} = I2C.open(bus_name)
    i2c
  end

  def read(i2c, sensor, low_power_mode, clock_stretch) do
    I2C.write!(i2c, sensor, wake_cmd())
    Process.sleep(1)
    I2C.write!(i2c, sensor, start_data_cmd(low_power_mode, clock_stretch))
    Process.sleep(read_delay(low_power_mode))
    <<temp_raw::16, _temp_crc, hum_raw::16, _hum_crc>> = I2C.read!(i2c, sensor, 6)
    I2C.write!(i2c, sensor, sleep_cmd())

    # TODO: Eventually check the CRC?

    temp_c = temp_raw |> convert_temp_c()
    %Reading{
      temperature_c: temp_c,
      temperature_f: temp_c |> convert_temp_c_to_f(),
      relative_humidity: hum_raw |> convert_rel_hum()
    }
  end

  defp start_data_cmd(true, true), do: <<0x64, 0x58>>
  defp start_data_cmd(true, false), do: <<0x60, 0x9C>>
  defp start_data_cmd(false, true), do: <<0x7C, 0xA2>>
  defp start_data_cmd(false, false), do: <<0x78, 0x66>>

  defp wake_cmd(), do: <<0x35, 0x17>>

  defp sleep_cmd(), do: <<0xB0, 0x98>>

  defp read_delay(true), do: 15
  defp read_delay(_), do: 1

  defp convert_temp_c(reading), do: (175 * reading / 65536) - 45
  defp convert_temp_c_to_f(temp_c), do: (temp_c * 9 / 5) + 32
  defp convert_rel_hum(reading), do: 100 * reading / 65536
end
