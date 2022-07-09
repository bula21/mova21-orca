class CreateJoinTableActivityStufeRecommended < ActiveRecord::Migration[6.0]
  def change
    create_table :activities_stufen_recommended, id: false do |t|
      t.integer :activity_id, null: false
      t.integer :stufe_id, null: false
    end
  end
end
