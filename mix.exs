defmodule Tensor.Mixfile do
  use Mix.Project

  def project do
    [app: :tensor,
     version: "0.0.1",
     elixir: "~> 1.4",
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Tensor.Application, []},
     extra_applications: [:logger, :runtime_tools]]
  end

  # Specifies which paths to compile per environment.
  # defp applications(:dev), do: applications(:all) ++ [:remix]
  defp applications(_all), do: [:logger, :rackla, :cowboy, :plug]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:rackla, "~> 1.2"},
     {:cowboy, "~> 1.0"},
     {:cors_plug, "~> 1.2"},
     {:uuid, "~> 1.1" },
     {:postgrex, ">= 0.0.0"}]
  end

end
