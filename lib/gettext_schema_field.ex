defmodule GettextSchemaField do
  @moduledoc """
  This module provides a helper method `translate_schema_field` to translate a changeset field
  based on PO files
  """

  @doc """
  Returns the translation of the field. If the msgstr is missing 
  in the PO file, the original field is returned
  """
  def translate_schema_field(gettext_module, changeset, field) do
    msgid = "#{module_name(changeset)}.#{field}"

    Gettext.dgettext(gettext_module, schema_fields_domain(), msgid, [])
    |> sanitize_result(msgid, field)
  end

  defp module_name(changeset), do: sanitized_module_name("#{changeset.data.__struct__}")

  defp sanitized_module_name("Elixir." <> rest), do: rest
  defp sanitized_module_name(module_name), do: module_name

  defp schema_fields_domain do
    Application.get_env(Mix.Project.config()[:app], :gettext_schema_file_name) || "schema"
  end

  # If the msgstr and the msgid are the same, assume that the translation is missing
  # and return the original field
  defp sanitize_result(msgid, msgid, field), do: field
  defp sanitize_result(msgstr, _msgid, _field), do: msgstr
end
