defmodule UnitFmt do
  alias UnitFmt.Math

  def format_binary(value) do
    {base, prefix, _} = binary_prefix(value)
    "#{base}#{prefix}"
  end

  def format_metric(value, unit \\ :base)

  def format_metric(value, unit) when value >= 0 do
    {base, prefix, _} = metric_prefix(value, unit)
    "#{base}#{prefix}"
  end

  def format_metric(value, unit) when value < 0 do
    "-#{format_metric(-value, unit)}"
  end

  @allowed_time_units [:millisecond, :second, :minute, :hour, :day]

  def format_time(value, unit \\ :millisecond)

  def format_time(value, unit) when value >= 0 and unit in @allowed_time_units do
    ms =
      case unit do
        :millisecond -> value
        :second -> value * 1000
        :minute -> value * 1000 * 60
        :hour -> value * 1000 * 60 * 60
        :day -> value * 1000 * 60 * 60 * 24
      end

    seconds =
      ms
      |> div(1000)
      |> rem(60)
      |> floor()

    minutes =
      ms
      |> div(1000)
      |> div(60)
      |> rem(60)
      |> floor()

    hours =
      ms
      |> div(1000)
      |> div(60)
      |> div(60)
      |> rem(24)
      |> floor()

    days = floor(ms / 24 / 60 / 60 / 1000)

    case {days, hours, minutes, seconds} do
      {0, 0, m, s} ->
        "#{padded2(m)}:#{padded2(s)}"

      {0, h, m, s} ->
        "#{padded2(h)}:#{padded2(m)}:#{padded2(s)}"

      {d, h, m, s} ->
        "#{d}:#{padded2(h)}:#{padded2(m)}:#{padded2(s)}"
    end
  end

  def format_time(value, unit) when value < 0 do
    "-" <> format_time(-value, unit)
  end

  defp padded2(num) when num >= 0 and num < 10 do
    "0#{num}"
  end

  defp padded2(num) when num >= 10 and num < 100 do
    "#{num}"
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
