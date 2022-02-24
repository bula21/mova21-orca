class AddTransportIdsToActivityExecution < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_executions, :transport_ids, :string
  end
end
