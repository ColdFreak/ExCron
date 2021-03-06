defmodule Agenda.Mixfile do
  use Mix.Project

  def project do
    [app: :agenda,
     version: "0.0.1",
     elixir: "~> 1.0.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger],
     registered: [Agenda.Worker],
     mod: {Agenda, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:good_times, "~> 1.0"},
      {:junit_formatter, "~> 0.0.3", only: :test}
    ]
  end
end
