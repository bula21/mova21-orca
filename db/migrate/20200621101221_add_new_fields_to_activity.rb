class AddNewFieldsToActivity < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :min_participants, :integer
    add_column :activities, :activity_type, :string
    add_reference :activities, :transport_location, foreign_key: true
  end
end
