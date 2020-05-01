class CreateJoinTableActivityStufe < ActiveRecord::Migration[6.0]
  def change
    create_join_table :activities, :stufen do |t|
      t.index [:activity_id, :stufe_id]
      t.index [:stufe_id, :activity_id]
    end
  end
end
