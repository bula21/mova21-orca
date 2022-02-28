class AddCalcMenuTokenToUnits < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :calc_menu_token, :string
  end
end
