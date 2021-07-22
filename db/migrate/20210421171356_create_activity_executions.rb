class CreateActivityExecutions < ActiveRecord::Migration[6.0]
  def change
    create_table :spots do |t|
      t.string :name
    end
    create_table :fields do |t|
      t.string :name
      t.references :spot, null: false, foreign_key: true
    end
    create_table :activity_executions do |t|
      t.references :activity, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :language_flags
      t.integer :amount_participants
      t.references :field, null: false, foreign_key: true
      t.timestamps
    end
  end
end
