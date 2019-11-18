class CreateLeaders < ActiveRecord::Migration[6.0]
  def change
    create_table :leaders do |t|
      t.integer :pbs_id
      t.string :last_name
      t.string :first_name
      t.string :scout_name
      t.date :birthdate
      t.string :gender
      t.string :email
      t.string :phone_number
      t.string :language

      t.timestamps
    end
  end
end
