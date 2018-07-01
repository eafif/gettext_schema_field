defmodule GettextSchemaField.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :gettext_schema_field,
      version: @version,
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      source_url: "https://github.com/eafif/gettext_schema_field",
      description: """
      GettextSchemaField can be use to for the internationalization of schema fields with Gettext.
      """
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:gettext, "~> 0.15"},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["eafif"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/eafif/gettext_schema_field"}
    ]
  end

  defp docs do
    [
      name: "Gettext Schema Field",
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: "https://github.com/eafif/gettext_schema_field",
    ]
  end
end
