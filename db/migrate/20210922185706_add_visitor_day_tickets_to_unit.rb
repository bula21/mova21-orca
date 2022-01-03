class AddVisitorDayTicketsToUnit < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :visitor_day_tickets, :integer, default: 0
  end
end
