class CreateUnitProgramChanges < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_program_changes do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :activity_execution, null: false, foreign_key: true
      t.references :unit_activity_execution, null: false, foreign_key: true
      t.boolean :notified_at
      t.text :remarks

      t.timestamps
    end
  end
end
