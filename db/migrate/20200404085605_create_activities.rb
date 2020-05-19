class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :label, null: false
      t.text :description
      t.string :language
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
