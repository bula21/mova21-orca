class CreateUnitContactLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :unit_contact_logs do |t|
      t.references :user
      t.references :unit
      t.timestamps
    end
  end
end
