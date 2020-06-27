class CreateTransportLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :transport_locations do |t|
      t.string :name
      t.integer :max_participants

      t.timestamps
    end
  end
end
