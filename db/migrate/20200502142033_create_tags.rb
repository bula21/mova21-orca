class CreateTags < ActiveRecord::Migration[6.0]
  def change
    create_table :tags do |t|
      t.string :code, null: false
      t.string :label, null: false
      t.string :icon, null: false

      t.timestamps
    end
  end
end
