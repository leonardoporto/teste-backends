defmodule FileCollector.MixProject do
  use Mix.Project

  def project do
    [
      app: :file_collector,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      included_applications: [:analyzer],
      extra_applications: [:logger],
      mod: {FileCollector.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:analyzer, path: "../analyzer"},
      {:file_system, "~> 0.2"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
    ]
  end
end
