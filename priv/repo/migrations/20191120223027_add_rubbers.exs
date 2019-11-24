defmodule RevScam.Repo.Migrations.AddRubbers do
  use Ecto.Migration

  def change do
    create table(:rubbers) do
      add(:name, :string)

      add(:speed, :float)
      add(:spin, :float)
      add(:control, :float)
      add(:tackiness, :float)
      add(:weight, :float)
      add(:sponge_hardness, :float)
      add(:gears, :float)
      add(:throw_angle, :float)
      add(:consistency, :float)
      add(:durability, :float)

      add(:overall, :float)
      add(:price, :float)
      add(:ratings, :integer)

      add(:brand_id, references(:brands))
      timestamps()
    end

    create(unique_index(:rubbers, [:name]))
  end
end
