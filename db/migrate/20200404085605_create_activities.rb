class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.jsonb :label, default: {}
      t.jsonb :description, default: {}
      t.string :language, null: false
      t.string :js_type
      t.integer :participants_count_activity
      t.integer :participants_count_transport
      t.integer :duration_activity
      t.integer :duration_journey
      t.string :location

      t.timestamps
    end
  end
end
