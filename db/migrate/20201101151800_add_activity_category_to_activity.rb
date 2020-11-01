class AddActivityCategoryToActivity < ActiveRecord::Migration[6.0]
  def change
    add_reference :activities, :activity_category, foreign_key: true
  end
end
