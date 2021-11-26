defmodule SHTC3.Reading do
  @derive {Jason.Encoder, only: [:temperature_c, :temperature_f, :relative_humidity]}
  defstruct [:temperature_c, :temperature_f, :relative_humidity]
end
