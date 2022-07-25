class AddStufeRecommendedActivityIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :activities_stufen_recommended, ["stufe_id", "activity_id"], name: "index_stufen_recommended_activities_index"
  end
end
