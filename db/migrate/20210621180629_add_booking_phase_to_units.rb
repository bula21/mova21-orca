class AddBookingPhaseToUnits < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :activity_booking_phase, :integer, default: 0
  end
end
