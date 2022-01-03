class AddAncestryToActivityCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_categories, :ancestry, :string
    add_column :activity_categories, :code, :string
    remove_column :activity_categories, :parent_id, :integer
    add_index :activity_categories, :ancestry
  end
end
