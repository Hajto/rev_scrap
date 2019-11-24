defmodule RevScam.Schema.Rubber do
  use Ecto.Schema
  import Ecto.Changeset

  alias RevScam.Schema.Brand

  @fields [
    :name,
    :speed,
    :spin,
    :control,
    :tackiness,
    :weight,
    :sponge_hardness,
    :gears,
    :throw_angle,
    :consistency,
    :durability,
    :overall,
    :price,
    :ratings
  ]

  schema "rubbers" do
    field :name, :string

    field :speed, :float
    field :spin, :float
    field :control, :float
    field :tackiness, :float
    field :weight, :float
    field :sponge_hardness, :float
    field :gears, :float
    field :throw_angle, :float
    field :consistency, :float
    field :durability, :float

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
