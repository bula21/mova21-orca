class CreateUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :units do |t|
      t.integer :pbs_id
      t.string :title
      t.string :abteilung
      t.integer :kv
      t.string :stufe
      t.integer :expected_participants_f
      t.integer :expected_participants_m
      t.integer :expected_participants_leitung_f
      t.integer :expected_participants_leitung_m
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :al, null: false, foreign_key: { to_table: 'leaders' }
      t.references :lagerleiter, null: false,  foreign_key: { to_table: 'leaders' }

      t.timestamps
    end
  end
end
