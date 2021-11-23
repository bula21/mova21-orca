class CreateUnitActivityExecutions < ActiveRecord::Migration[6.0]
  def change
    create_table :unit_activity_executions do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :activity_execution, null: false, foreign_key: true
      t.integer :headcount, null: true

      t.timestamps
    end
  end
end
