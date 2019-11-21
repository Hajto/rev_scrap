defmodule RevScam.Schema.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  schema "brands" do
    field :name, :string
    timestamps()

    has_many :blades, RevScam.Schema.Blade
    has_many :rubbers, RevScam.Schema.Rubber
  end

  def changeset(data, attrs) do
    cast(data, attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
