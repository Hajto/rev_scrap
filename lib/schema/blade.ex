defmodule RevScam.Schema.Blade do
  use Ecto.Schema
  import Ecto.Changeset

  alias RevScam.Schema.Brand

  @fields [:name, :speed, :stiffness, :control, :overall, :price, :ratings]

  schema "blades" do
    field :name, :string
    field :speed, :float
    field :control, :float
    field :stiffness, :float
    field :overall, :float
    field :price, :float
    field :ratings, :integer

    belongs_to :brand, Brand
    timestamps()
  end

  def changeset(%__MODULE__{} = data, attrs) do
    cast(data, attrs, @fields ++ [:brand_id])
    |> validate_required(@fields)
    |> unique_constraint(:name)
  end
end
