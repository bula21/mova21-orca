class AddMoreFieldsToVisitorDays < ActiveRecord::Migration[6.0]
  def change
    add_column :unit_visitor_days, :responsible_firstname, :string, null: true
    add_column :unit_visitor_days, :responsible_place, :string, null: true
    add_column :unit_visitor_days, :responsible_postal_code, :string, null: true
    add_column :unit_visitor_days, :responsible_salutation, :string, null: true
    
    rename_column :unit_visitor_days, :responsible_name, :responsible_lastname
  end
end
