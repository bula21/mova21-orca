class CreateUnitVisitorDays < ActiveRecord::Migration[6.0]
  def change
    create_table :unit_visitor_days do |t|
      t.references :unit, null: false, foreign_key: true
      t.integer :u6_tickets, null: false, default: 0
      t.integer :u16_tickets, null: false, default: 0
      t.integer :u16_ga_tickets, null: false, default: 0
      t.integer :ga_tickets, null: false, default: 0
      t.integer :other_tickets, null: false, default: 0
      t.text :responsible_contact
      t.string :responsible_email
      t.string :responsible_phone
      t.integer :phase, default: 0, null: false

      t.timestamps
    end
  end
end
