class AddQuartierToUnit < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :district, :string
    add_column :units, :week, :string
  end
end
