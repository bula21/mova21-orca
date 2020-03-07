class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :type
      t.date :issued_at, default: -> { "CURRENT_TIMESTAMP" }
      t.date :payable_until
      t.datetime :sent_at
      t.text :text, null: true
      t.text :invoice_address, null: true
      t.string :ref
      t.decimal :amount, default: "0.0"
      t.boolean :paid, default: false
      t.string :payment_info_type
      t.integer :category, default: 0, null: true

      t.timestamps
    end
  end
end
