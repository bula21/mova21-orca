class AddRolesFlagToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :role_flags, :integer, default: 0
    
    User.find_each do |user|
      user.update({
        role_user: user.role == 0,
        role_admin: user.role == 1,
        role_programm: user.role == 2
      })
    end
  end

  def down
    remove_column :users, :role_flags, :integer, default: 0
  end
end
