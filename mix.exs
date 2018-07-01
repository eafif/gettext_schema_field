defmodule GettextSchemaField.MixProject do
  use Mix.Project

  def project do
    [
      app: :gettext_schema_field,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    []
  end

  defp deps do
    [

    ]
  end

  defp package do
    [
      maintainers: ["eafif"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/eafif/gettext_schema_field"}
    ]
  end
end
