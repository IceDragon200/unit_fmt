defmodule UnitFmtTest do
  use ExUnit.Case

  describe "format_binary/1" do
    test "will format a zero" do
      assert "0" == UnitFmt.format_binary(0)
      assert "0" == UnitFmt.format_binary(0.0)
    end

    test "can handle negative numbers, but without prefixes" do
      assert "-1" == UnitFmt.format_binary(-1)
    end

    test "will format all numbers (with suffixes)" do
      assert "1" == UnitFmt.format_binary(1)
      assert "1Ki" == UnitFmt.format_binary(:math.pow(2, 10))
      assert "1Mi" == UnitFmt.format_binary(:math.pow(2, 20))
      assert "1Gi" == UnitFmt.format_binary(:math.pow(2, 30))
      assert "1Ti" == UnitFmt.format_binary(:math.pow(2, 40))
      assert "1Pi" == UnitFmt.format_binary(:math.pow(2, 50))
      assert "1Ei" == UnitFmt.format_binary(:math.pow(2, 60))
      assert "1Zi" == UnitFmt.format_binary(:math.pow(2, 70))
      assert "1Yi" == UnitFmt.format_binary(:math.pow(2, 80))
      assert "1024Yi" == UnitFmt.format_binary(:math.pow(2, 90))
    end
  end

  describe "format_metric/2" do
    test "will format a zero" do
      assert "0" == UnitFmt.format_metric(0, :base)
      assert "0" == UnitFmt.format_metric(0.0, :base)
    end

    test "will format a negative number" do
      assert "-10" == UnitFmt.format_metric(-10.0, :base)
    end

    test "will format a positive number" do
      assert "10" == UnitFmt.format_metric(10.0, :base)
    end

    test "will format all numbers (with suffixes)" do
      assert "1f" == UnitFmt.format_metric(0.000000000000001, :base)
      assert "1p" == UnitFmt.format_metric(0.000000000001, :base)
      assert "1n" == UnitFmt.format_metric(0.000000001, :base)
      assert "1μ" == UnitFmt.format_metric(0.000001, :base)
      assert "1m" == UnitFmt.format_metric(0.001, :base)
      assert "1" == UnitFmt.format_metric(1, :base)
      assert "1k" == UnitFmt.format_metric(1_000, :base)
      assert "1M" == UnitFmt.format_metric(1_000_000, :base)
      assert "1G" == UnitFmt.format_metric(1_000_000_000, :base)
      assert "1T" == UnitFmt.format_metric(1_000_000_000_000, :base)
      assert "1P" == UnitFmt.format_metric(1_000_000_000_000_000, :base)
      assert "1E" == UnitFmt.format_metric(1_000_000_000_000_000_000, :base)
    end
  end
end
