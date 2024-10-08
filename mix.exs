defmodule Kiosk.MixProject do
  use Mix.Project

  def project do
    [
      app: :kiosk,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Kiosk.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:banshee, "~> 0.1.0", git: "https://github.com/MinasMazar/banshee.git"},
      {:bandit, "~> 1.0"},
      {:plug, "~> 1.16.1"},
      {:tzdata, "~> 1.1"}
    ]
  end
end
