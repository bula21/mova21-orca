class CreateUnitActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :unit_activities do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.integer :priority, null: true
      t.text :remarks

      t.timestamps
    end
    add_index :unit_activities, :priority
  end
end
