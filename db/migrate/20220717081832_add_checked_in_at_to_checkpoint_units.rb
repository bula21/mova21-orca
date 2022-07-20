class AddCheckedInAtToCheckpointUnits < ActiveRecord::Migration[6.1]
  def change
    add_column :checkpoint_units, :checked_in_at, :datetime
  end
end
