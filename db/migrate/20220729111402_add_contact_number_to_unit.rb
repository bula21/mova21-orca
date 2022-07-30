class AddContactNumberToUnit < ActiveRecord::Migration[6.1]
  def change
    add_column :units, :contact_phonenumber_1, :string
    add_column :units, :contact_phonenumber_2, :string
  end
end
