defmodule Mix.Tasks.Gettext.SchemaFields do
  use Mix.Task

  @shortdoc "Generates a POT file for schema fields"

  @default_file_name "schema"

  def run(_args) do
    force_compile()

    mix_config = Mix.Project.config()

    {:ok, _} = Application.ensure_all_started(mix_config[:app])

    {:ok, modules} = :application.get_key(mix_config[:app], :modules)

    file_path = Path.absname("priv/gettext/#{Application.get_env(mix_config[:app], :gettext_schema_file_name) || @default_file_name}.pot", File.cwd!)

    Mix.shell.info "Writing schema fields to #{file_path}"

    file_path
    |> File.write!("")

    Enum.each(modules, &extract_fields_from_module(&1, file_path))

    Mix.shell.info "Done! Run `mix gettext.merge priv/gettext` to merge into PO files"
  end

  defp force_compile do
    Mix.Task.reenable("compile.elixir")
    Mix.Task.run("compile")
    Mix.Task.run("compile.elixir")
  end
  
  defp extract_fields_from_module(module, file_path) do
    case Keyword.fetch(module.__info__(:functions), :__schema__) do
      {:ok, _} ->
        add_fields_to_pot_file(module, file_path)
      _ ->
        :no_schema
    end
  end

  defp add_fields_to_pot_file(module, file_path) do
    File.write!(file_path, "# #{sanitized_module_name("#{module}")}\n", [:append])

    Enum.each(module.__schema__(:fields), &write_field_to_pot_file(&1, module, file_path))
    
    File.write!(file_path, "\n", [:append])
  end

  defp write_field_to_pot_file(field, module, file_path) do
    file_path
    |> File.write!("msgid \"#{sanitized_module_name("#{module}")}.#{field}\"\nmsgstr \"\"\n\n", [:append])
  end

  defp sanitized_module_name("Elixir." <> rest), do: rest
  defp sanitized_module_name(module_name), do: module_name
end
