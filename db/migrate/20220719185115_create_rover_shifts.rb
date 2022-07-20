class CreateRoverShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :rover_shifts do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :place
      t.integer :job_id
      t.jsonb :rovers

      t.timestamps
    end
    
    create_join_table :activity_executions, :rover_shifts, table_name: :activity_execution_rover_shifts
  end
end
