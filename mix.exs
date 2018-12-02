defmodule Elixir18.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_18,
      version: "0.1.0",
      elixir: "~> 1.8.0-dev or ~>1.8.0-rc or ~> 1.8",
      archives: [nerves_bootstrap: "~> 1.0"],
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.target() != :host,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  # Starting nerves_bootstrap adds the required aliases to Mix.Project.config()
  # Aliases are only added if MIX_TARGET is set.
  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Elixir18.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nerves, github: "nerves-project/nerves", branch: "elixir-18", override: true, runtime: false},
      {:shoehorn, "~> 0.4"},
      {:ring_logger, "~> 0.6"},
      {:toolshed, "~> 0.2"}
    ] ++ deps(Mix.target())
  end

  # Specify target specific dependencies
  defp deps(:host), do: []

  defp deps(_target) do
    [
      {:nerves_runtime, "~> 0.6"},
      {:nerves_init_gadget, "~> 0.4"},
      {:nerves_system_rpi, "~> 1.5", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.5", runtime: false, targets: :rpi0},
      {:nerves_system_rpi2, "~> 1.5", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 1.5", runtime: false, targets: :rpi3},
      {:nerves_system_bbb, "~> 2.0", runtime: false, targets: :bbb},
      {:nerves_system_x86_64, "~> 1.5", runtime: false, targets: :x86_64},
    ]
  end
end
