class AddRootCampUnitIdToUnits < ActiveRecord::Migration[6.0]
  def change
    remove_reference :units, :al, null: false, foreign_key: { to_table: 'leaders' }
    add_reference :units, :al, null: true, foreign_key: { to_table: 'leaders' }
    add_reference :units, :coach, null: true, foreign_key: { to_table: 'leaders' }
    add_column :units, :midata_data, :jsonb, null: true
  end
end
