defmodule RevScam.Schema.Rubber do
  use Ecto.Schema
  import Ecto.Changeset

  alias RevScam.Schema.Brand

  @fields [:name, :speed, :spin, :tackiness, :overall, :price, :ratings]

  schema "rubbers" do
    field :name, :string
    field :speed, :float
    field :spin, :float
    field :tackiness, :float
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
