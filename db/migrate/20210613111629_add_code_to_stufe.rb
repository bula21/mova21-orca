class AddCodeToStufe < ActiveRecord::Migration[6.0]
  def change
    add_column :stufen, :code, :string
  end
end
