class AddRoleToParticipantUnits < ActiveRecord::Migration[6.0]
  def up
    add_column :participant_units, :role, :string, null: true

    # ParticipantUnit.reset_column_information
    # ParticipantUnit.find_each do |participation|
    #   participation.update(role: participation.participant.role) if participation.role.blank?
    # end

    # remove_column :participants, :role, :string, null: true
  end

  def down
    remove_column :participant_units, :role, :string, null: true
    # add_column :participants, :role, :string, null: true
  end
end
