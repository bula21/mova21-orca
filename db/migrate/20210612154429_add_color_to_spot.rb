class AddColorToSpot < ActiveRecord::Migration[6.0]
  def change
    add_column :spots, :color, :string
  end
end
