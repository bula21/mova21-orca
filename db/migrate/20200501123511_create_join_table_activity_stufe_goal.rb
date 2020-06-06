class CreateJoinTableActivityStufeGoal < ActiveRecord::Migration[6.0]
  def change
    create_join_table :activities, :goals do |t|
      t.index [:activity_id, :goal_id]
      t.index [:goal_id, :activity_id]
    end
  end
end
