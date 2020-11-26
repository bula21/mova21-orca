class ChangeDurationToString < ActiveRecord::Migration[6.0]
  def change
    change_column :activities, :duration_activity, :string
    change_column :activities, :duration_journey, :string
  end
end
