defmodule UnitFmt.MixProject do
  use Mix.Project

  def project do
    [
      app: :unit_fmt,
      version: "0.2.0",
      description: description(),
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      source_url: "https://github.com/IceDragon200/unit_fmt",
      homepage_url: "https://github.com/IceDragon200/unit_fmt",
    ]
  end

  defp description do
    """
    A simple module for formatting numbers with a unit prefix.
    """
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
    ]
  end

  defp package do
    [
      maintainers: ["Corey Powell"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/IceDragon200/unit_fmt"
      },
    ]
  end
end
