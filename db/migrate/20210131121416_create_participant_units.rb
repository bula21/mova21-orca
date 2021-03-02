class CreateParticipantUnits < ActiveRecord::Migration[6.0]
  def up
    create_table :participant_units do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: true
    end
    execute <<-SQL
      INSERT INTO participant_units(participant_id, unit_id) 
      SELECT id as participant_id, unit_id FROM participants where unit_id IS NOT NULL
    SQL
    remove_column :participants, :unit_id, null: true, foreign_key: true
  end

  def down
    add_reference :participants, :unit, null: true, foreign_key: true
    Rails.logger.warn "All participants which had multiple units might be corrupted. It just took the first"
    execute <<-SQL
      UPDATE participants 
        SET 
      unit_id=(SELECT unit_id FROM participant_units WHERE participant_id = participants.id LIMIT 1)
    SQL
    change_column_null :participants, :unit_id, false
    drop_table :participant_units
  end
end
