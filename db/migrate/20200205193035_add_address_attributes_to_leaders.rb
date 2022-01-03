class AddAddressAttributesToLeaders < ActiveRecord::Migration[5.2]
  def change
    add_column :leaders, :address, :string
    add_column :leaders, :zip_code, :string
    add_column :leaders, :town, :string
    add_column :leaders, :country, :string
  end
end
