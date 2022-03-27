class AddLtbAcceptedFlagToUnitVisitorDay < ActiveRecord::Migration[6.1]
  def change
    add_column :unit_visitor_days, :ltb_accepted, :boolean
  end
end
