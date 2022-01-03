class OpenVisitorDaysForUnits < ActiveRecord::Migration[6.0]
  def up
    Unit.find_each do |unit|
      unit.create_unit_visitor_day!(phase: :open)
    end
  end
end
