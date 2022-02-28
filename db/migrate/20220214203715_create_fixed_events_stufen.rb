class CreateFixedEventsStufen < ActiveRecord::Migration[6.0]
  def change
    create_table :fixed_events_stufen do |t|
      t.references :fixed_event, null: false, foreign_key: true
      t.references :stufe, null: false, foreign_key: true
    end
    all_stufen =  Stufe.all
    FixedEvent.all.each { |fe| fe.update(stufen: all_stufen)}
  end
end
