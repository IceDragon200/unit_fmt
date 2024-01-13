defmodule UnitFmt do
  binary_units = [
    # Yobi
    {:math.pow(2, 80), "Yi"},
    # Zebi
    {:math.pow(2, 70), "Zi"},
    # Exbi
    {:math.pow(2, 60), "Ei"},
    # Pebi
    {:math.pow(2, 50), "Pi"},
    # Tebi
    {:math.pow(2, 40), "Ti"},
    # Gibi
    {:math.pow(2, 30), "Gi"},
    # Mebi
    {:math.pow(2, 20), "Mi"},
    # Kibi
    {:math.pow(2, 10), "Ki"},
    # base
    {1, ""},
  ]

  for {threshold, suffix} <- binary_units do
    def format_binary(value) when is_number(value) and unquote(threshold) <= value do
      normalize_float(value / unquote(threshold), unquote(suffix))
    end
  end

  def format_binary(value) when is_integer(value) and value <= 0 do
    Integer.to_string(value)
  end

  def format_binary(value) when is_float(value) and value <= 0.0 do
    normalize_float(value, "")
  end

  @spec format_metric(number, :micro | :milli | :base) :: String.t()
  def format_metric(value, base \\ :base)

  def format_metric(value, :micro) when is_number(value) do
    format_metric(value / 1_000_000, :base)
  end

  def format_metric(value, :milli) when is_number(value) do
    format_metric(value / 1_000, :base)
  end

  def format_metric(value, :base) when is_integer(value) and value <= 0 do
    Integer.to_string(value)
  end

  def format_metric(value, :base) when is_float(value) and value <= 0.0 do
    normalize_float(value, "")
  end

  metric_units = [
    # Exa
    {1_000_000_000_000_000_000, "E"},
    # Peta
    {1_000_000_000_000_000, "P"},
    # Tera
    {1_000_000_000_000, "T"},
    # Giga
    {1_000_000_000, "G"},
    # Mega
    {1_000_000, "M"},
    # Kilo
    {1_000, "k"},
    # base
    {1, ""},
    # Milli
    {1.0e-3, "m"},
    # Micro
    {1.0e-6, "μ"},
    # Nano
    {1.0e-9, "n"},
    # Pico
    {1.0e-12, "p"},
    # Femto
    {1.0e-15, "f"},
  ]

  for {threshold, suffix} <- metric_units do
    def format_metric(value, :base) when is_number(value) and unquote(threshold) <= value do
      normalize_float(value / unquote(threshold), unquote(suffix))
    end
  end

  defp normalize_float(value, suffix) do
    value = Float.round(value, 2)

    if Float.floor(value) == value do
      to_string(floor(value)) <> suffix
    else
      IO.iodata_to_binary(:io_lib.format("~.2f~s", [value, suffix]))
    end
  end
end
