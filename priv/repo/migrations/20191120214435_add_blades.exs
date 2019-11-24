defmodule RevScam.Repo.Migrations.AddBlades do
  use Ecto.Migration

  def change do
    create table(:blades) do
      add(:name, :string)

      add(:speed, :float)
      add(:control, :float)
      add(:stiffness, :float)
      add(:hardness, :float)
      add(:consistency, :float)

      add(:overall, :float)
      add(:price, :float)
      add(:ratings, :integer)

      add(:brand_id, references(:brands))
      timestamps()
    end

    create(unique_index(:blades, [:name]))
  end
end
