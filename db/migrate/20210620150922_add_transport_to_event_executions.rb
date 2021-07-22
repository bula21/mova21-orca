class AddTransportToEventExecutions < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_executions, :transport, :boolean
  end
end
