defmodule Elixir2fa.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir2fa,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "Elixir2fa",
      source_url: "https://github.com/codenoid/elixir-two-factor-auth"
    ]
  end

  defp description do
    """
    Library for generating QR-Code, Random Secret and Verify Time Based Password
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Rubi Jihantoro"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/codenoid/elixir-two-factor-auth"}
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
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
    ]
  end
end
