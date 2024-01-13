defmodule UnitFmt do
  alias UnitFmt.Math

  def format_binary(value) do
    {base, prefix, _} = binary_prefix(value)
    "#{base}#{prefix}"
  end

  def format_metric(value, unit \\ :base) do
    {base, prefix, _} = metric_prefix(value, unit)
    "#{base}#{prefix}"
  end

  binary_units = [
    {Math.ipow(2, 80), "Yi", "yobi"},
    {Math.ipow(2, 70), "Zi", "zebi"},
    {Math.ipow(2, 60), "Ei", "exbi"},
    {Math.ipow(2, 50), "Pi", "pebi"},
    {Math.ipow(2, 40), "Ti", "tebi"},
    {Math.ipow(2, 30), "Gi", "gibi"},
    {Math.ipow(2, 20), "Mi", "mebi"},
    {Math.ipow(2, 10), "Ki", "kibi"},
    {1, "", ""},
  ]

  metric_units = [
    {Math.pow(10, 30), "Q", "quetta"},
    {Math.pow(10, 27), "R", "ronna"},
    {Math.pow(10, 24), "Y", "yotta"},
    {Math.pow(10, 21), "Z", "zetta"},
    {Math.pow(10, 18), "E", "exa"},
    {Math.pow(10, 15), "P", "peta"},
    {Math.pow(10, 12), "T", "tera"},
    {Math.pow(10, 9), "G", "giga"},
    {Math.pow(10, 6), "M", "mega"},
    {Math.pow(10, 3), "k", "kilo"},
    {1, "", ""},
    {1.0e-3, "m", "milli"},
    {1.0e-6, "μ", "micro"},
    {1.0e-9, "n", "nano"},
    {1.0e-12, "p", "pico"},
    {1.0e-15, "f", "femto"},
  ]

  @spec binary_prefix(number()) :: {String.t(), String.t(), String.t()}
  for {threshold, prefix, prefix_name} <- binary_units do
    def binary_prefix(value) when is_number(value) and unquote(threshold) <= value do
      {normalize_float(value / unquote(threshold)), unquote(prefix), unquote(prefix_name)}
    end
  end

  def binary_prefix(value) when is_integer(value) and value <= 0 do
    {Integer.to_string(value), "", ""}
  end

  def binary_prefix(value) when is_float(value) and value <= 0.0 do
    {normalize_float(value), "", ""}
  end

  @spec metric_prefix(number, :micro | :milli | :base) :: {String.t(), String.t(), String.t()}
  def metric_prefix(value, base \\ :base)

  def metric_prefix(value, :micro) when is_number(value) do
    metric_prefix(value / 1_000_000, :base)
  end

  def metric_prefix(value, :milli) when is_number(value) do
    metric_prefix(value / 1_000, :base)
  end

  def metric_prefix(value, :base) when is_integer(value) and value <= 0 do
    {Integer.to_string(value), "", ""}
  end

  def metric_prefix(value, :base) when is_float(value) and value <= 0.0 do
    {normalize_float(value), "", ""}
  end

  for {threshold, prefix, prefix_name} <- metric_units do
    def metric_prefix(value, :base) when is_number(value) and unquote(threshold) <= value do
      {normalize_float(value / unquote(threshold)), unquote(prefix), unquote(prefix_name)}
    end
  end

  defp normalize_float(value) when is_float(value) do
    if :math.floor(value) == value do
      Integer.to_string(floor(value))
    else
      :erlang.float_to_binary(value, decimals: 2)
    end
  end
end
