class CreateStufen < ActiveRecord::Migration[6.0]
  def change
    create_table :stufen do |t|
      t.jsonb :name, default: {}

      t.timestamps
    end


  end
end
