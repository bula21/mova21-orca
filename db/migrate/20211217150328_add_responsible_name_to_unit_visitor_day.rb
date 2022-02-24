class AddResponsibleNameToUnitVisitorDay < ActiveRecord::Migration[6.0]
  def change
    add_column :unit_visitor_days, :responsible_name, :string, null: true
    rename_column :unit_visitor_days, :responsible_contact, :responsible_address
  end
end
