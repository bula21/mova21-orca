class AddTransportModeToUnit < ActiveRecord::Migration[6.1]
  def change
    add_column :units, :transport_mode, :string
  end
end
