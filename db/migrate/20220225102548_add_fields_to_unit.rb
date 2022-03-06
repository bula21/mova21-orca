class AddFieldsToUnit < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :definite_max_number_of_persons, :integer
    add_column :units, :amount_of_rovers, :integer
    add_column :units, :arrival_slot, :string
    add_column :units, :departure_slot, :string
    add_column :units, :hand_over_camp_at, :datetime
  end
end
