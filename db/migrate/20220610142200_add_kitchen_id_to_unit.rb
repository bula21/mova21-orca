class AddKitchenIdToUnit < ActiveRecord::Migration[6.1]
    def change
      add_column :units, :kitchen_id, :string
      rename_column :units, :calc_menu_token, :food_pickup_slot
    end
  end
  