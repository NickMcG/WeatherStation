defmodule Shtc3.MixProject do
  use Mix.Project

  def project do
    [
      app: :shtc3,
      version: "0.1.0",
      elixir: "~> 1.13-rc",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:circuits_i2c, "~> 1.0.0"},
      {:cerlc, "~> 0.2.1"},
      {:jason, "~> 1.2.2"}
    ]
  end
end
