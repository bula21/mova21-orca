class AddGuestTruppToParticipant < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :guest_troop, :string
    add_column :units, :expected_guest_participants, :integer
    add_column :units, :expected_guest_leaders, :integer
  end
end
