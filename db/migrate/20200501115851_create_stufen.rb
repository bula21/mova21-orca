class CreateStufen < ActiveRecord::Migration[6.0]
  def change
    create_table :stufen do |t|
      t.string :name

      t.timestamps
    end


  end
end
