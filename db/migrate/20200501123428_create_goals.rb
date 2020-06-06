class CreateGoals < ActiveRecord::Migration[6.0]
  def change
    create_table :goals do |t|
      t.string :name

      t.timestamps
    end

    Goal.create(name: 'Pfadi (er) leben')
    Goal.create(name: 'Diversität und Inklusion')
    Goal.create(name: 'Umwelt')
    Goal.create(name: 'Prävention')
    Goal.create(name: 'Dimension und Austausch')
  end
end
