class AddShiftPriorityAndJobIdToActivities < ActiveRecord::Migration[6.1]
  def change
    add_column :activities, :rover_shift_prio, :integer, null: true
    add_column :activities, :rover_job_id, :integer, null: true
    add_column :activities, :required_rovers, :integer, null: true
  end
end
