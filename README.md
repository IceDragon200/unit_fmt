# UnitFmt

A simple module for formatting numbers.

## Features

### `format_metric`

Formats a number using the metric SI units.

```elixir
# Metric prefixes
UnitFmt.format_metric(1_000_000) #=> 1M
UnitFmt.format_metric(1_000) #=> 1K
UnitFmt.format_metric(1) #=> 1
UnitFmt.format_metric(0.001) #=> 1m
```

### `format_binary`

Formats a number using binary units.

```elixir
UnitFmt.format_binary(1024) #=> 1Ki
```

### `format_time`

Formats a number as a timestamp in the form of: `DD:HH:mm:ss`

Note. `DD:HH` are optional, their segments will be excluded if the minimum is not met.

```elixir
UnitFmt.format_time(2000, :millisecond) #=> 00:02
UnitFmt.format_time(120, :second) #=> 02:00
UnitFmt.format_time(120, :minute) #=> 02:00:00
UnitFmt.format_time(48, :hour) #=> 2:00:00:00
```

## Installation

Include `unit_fmt` in your application:

```elixir
  def deps do
    [
      ...
      {:unit_fmt, git: "https://github.com/IceDragon200/unit_fmt.git"},
    ]
  end
```

At the time of this writing (2024-07-26), `unit_fmt` is not available in hex (yet).
