class AddSimoToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :simo, :string
  end
end
