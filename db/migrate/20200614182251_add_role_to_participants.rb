class AddRoleToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :role, :string
  end
end
