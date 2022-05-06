class AllowNullOnUnitProgramChanges < ActiveRecord::Migration[6.1]
  def change
    change_column_null :unit_program_changes, :unit_activity_execution_id, true
    change_column_null :unit_program_changes, :activity_execution_id, true
  end
end
