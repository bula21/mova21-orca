class AddPbsIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :pbs_id, :integer
  end
end
