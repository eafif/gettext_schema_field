# GettextSchemaField

GettextSchemaField can be use for the internationalization of schema fields with Gettext, such as the ones defined with Ecto. For example:

```elixir
defmodule Hello.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end
end
```

will generate the following in `schema.pot`:

```
# Hello.Accounts.User
msgid "Hello.Accounts.User.id"
msgstr ""

msgid "Hello.Accounts.User.email"
msgstr ""

msgid "Hello.Accounts.User.first_name"
msgstr ""

msgid "Hello.Accounts.User.last_name"
msgstr ""

msgid "Hello.Accounts.User.updated_at"
msgstr ""
```

## Installation

The package can be installed
by adding `gettext_schema_field` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gettext_schema_field, "~> 0.1.0"}
  ]
end
```

## Generating .pot file

To generate the `.pot` file containing all schema fields, run:

```console
$ mix gettext.schema_fields
```

By default, this will generate `schema.pot` file under `priv/gettext`.

You can override the name of the file in `config.exs`. For instance, if you want the generated `.pot` file to be called `my_schema.pot`:

```elixir
config :my_app, gettext_schema_file_name: "my_schema"
```

Once a `.pot` file has been generated, run `mix gettext.merge priv/gettext` to merge the `.pot` file into `.po`. Refer to the Gettext documentation for more info.

## Translating schema fields in your application

GettextSchemaField provides a utility function `translate_schema_field`, to translate a field from a changeset:

```elixir
GettextSchemaField.translate_schema_field(MyApp.Gettext, changeset, field)
```

## Sample usage in Phoenix JSON View

```elixir
# hello_web/views/changeset_view.ex

defmodule HelloWeb.ChangesetView do
  use HelloWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `HelloWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def translate_errors_and_fields(changeset) do
    changeset
    |> translate_errors
    |> Enum.map(fn {field, errors} -> {translate_field(changeset, field), errors} end)
    |> Enum.into(%{})
  end

  defp translate_field(changeset, field) do
    GettextSchemaField.translate_schema_field(HelloWeb.Gettext, changeset, field)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors_and_fields(changeset)}
  end
end
```