defmodule UnitFmt.Math do
  defdelegate pow(x, y), to: :math

  def ipow(x, y) do
    floor(:math.pow(x, y))
  end
end
