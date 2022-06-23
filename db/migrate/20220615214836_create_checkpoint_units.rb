class CreateCheckpointUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :checkpoint_units do |t|
      t.references :checkpoint, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true

      t.text :notes_check_in
      t.boolean :checked_in_on_paper, default: false
      # created by is essencially checked_in_at
      t.references :check_in_by, foreign_key: { to_table: :users }
      t.datetime :confirmed_checked_in_at
      t.references :confirmed_check_in_by, foreign_key: { to_table: :users }

      t.text :notes_check_out
      t.boolean :check_out_ok
      t.float :cost_in_chf
      t.datetime :checked_out_at
      t.references :check_out_by, foreign_key: { to_table: :users }
      t.boolean :checked_out_on_paper, default: false
      t.datetime :confirmed_checked_out_at
      t.references :confirmed_check_out_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :checkpoint_units, [:checkpoint_id, :unit_id], unique: true
  end
end
