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
    
    create_table :activity_execution_rover_shifts do |t|
      t.references :activity_execution, foreign_key: true
      t.references :rover_shift, foreign_key: true
    end
  end
end
