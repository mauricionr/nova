defmodule Gcommerce.Repo.Migrations.CreateOptionType do
  use Ecto.Migration

  def change do
    create table(:option_types) do
      add :name, :string
      add :display_name, :string

      timestamps
    end

    create unique_index(:option_types, [:name])
  end
end
