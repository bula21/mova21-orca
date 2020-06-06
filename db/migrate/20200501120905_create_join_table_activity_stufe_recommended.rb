class CreateJoinTableActivityStufeRecommended < ActiveRecord::Migration[6.0]
  def change
    create_table :activities_stufen_recommended, id: false do |t|
      t.bigint :activity_id, null: false
      t.bigint :stufe_id, null: false
    end
  end
end
