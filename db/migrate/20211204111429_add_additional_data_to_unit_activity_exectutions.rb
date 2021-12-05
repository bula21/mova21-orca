class AddAdditionalDataToUnitActivityExectutions < ActiveRecord::Migration[6.0]
  def change
    add_column :unit_activity_executions, :additional_data, :jsonb, null: true
  end
end
