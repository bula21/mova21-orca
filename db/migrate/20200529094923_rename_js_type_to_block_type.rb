class RenameJsTypeToBlockType < ActiveRecord::Migration[6.0]
  def change
    rename_column :activities, :js_type, :block_type
  end
end
