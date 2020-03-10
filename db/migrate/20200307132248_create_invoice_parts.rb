class CreateInvoiceParts < ActiveRecord::Migration[6.0]
  def change
    create_table :invoice_parts do |t|
      t.references :invoice, null: false, foreign_key: true
      t.string :type
      t.decimal :amount
      t.string :label
      t.string :breakdown
      t.integer :ordinal

      t.timestamps
    end
  end
end
