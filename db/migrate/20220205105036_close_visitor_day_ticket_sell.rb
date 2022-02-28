class CloseVisitorDayTicketSell < ActiveRecord::Migration[6.0]
  def up
    UnitVisitorDay.transaction do
      UnitVisitorDay.find_each { _1.phase_closed! }
    end
  end

  def down
    UnitVisitorDay.transaction do
      UnitVisitorDay.find_each { _1.phase_open! }
    end
  end
end
