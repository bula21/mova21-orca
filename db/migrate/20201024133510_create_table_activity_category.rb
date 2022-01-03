class CreateTableActivityCategory < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_categories do |t|
      t.jsonb :label, default: {}
      t.references :parent, foreign_key: { to_table: :activity_categories }
    end
  end
end
