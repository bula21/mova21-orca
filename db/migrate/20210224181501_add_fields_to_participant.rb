class AddFieldsToParticipant < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :email, :string, default: ''
    add_column :participants, :phone_number, :string, default: ''
  end
end
