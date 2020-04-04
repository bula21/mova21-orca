class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :scout_name
      t.references :unit, null: false, foreign_key: true
      t.string :gender
      t.date :birthdate
      t.integer :pbs_id

      t.timestamps
    end
  end
end
