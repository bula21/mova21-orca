class RenameKvToKvIdOnUnit < ActiveRecord::Migration[6.0]
  def change
    rename_column :units, :kv, :kv_id
  end
end
