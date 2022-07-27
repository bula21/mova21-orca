# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative 'test_seeder'

if ENV['testdata'].eql?('yes')
  TestSeeder.new.seed
else
  require_relative 'seed_data/base_data'
  al = FactoryBot.create(:leader, scout_name: 'Lego')
  lagerleiter = FactoryBot.create(:leader, scout_name: 'Duplo', phone_number: '+41 79 123 45 67', email: 'duplo@example.ch')

  FactoryBot.create(:unit, title: 'Sommerlager Pfadistufe', stufe: Stufe.find_by(code: :wolf), abteilung: 'Pfadi H2O',
                    al: al, lagerleiter: lagerleiter)
  FactoryBot.create(:unit, title: 'Sommerlager Wolfsstufe', stufe: Stufe.find_by(code: :pfadi), abteilung: 'Pfadi H2O',
                    al: al, lagerleiter: lagerleiter)

  activity_1 = ActivityCategory.create(label_de: 'Ausflug', code: 'excursion')
  ActivityCategory.create(label_de: 'Aktivität', code: 'activity')
  ActivityCategory.create(label_de: 'Frohnarbeit', code: 'frohnarbeit')
  ActivityCategory.create([
                            { label_de: 'Wasser', ancestry: activity_1 },
                            { label_de: 'Berg', ancestry: activity_1 }
                          ])

  Goal.create(name: 'Pfadi (er) leben')
  Goal.create(name: 'Diversität und Inklusion')
  Goal.create(name: 'Umwelt')
  Goal.create(name: 'Prävention')
  Goal.create(name: 'Dimension und Austausch')

  activities = FactoryBot.create_list(:activity, 20)

  spots = Spot.create([{ name: "Lagerplatz" }, { name: "Flugplatz" }])
  Field.create([
                 { name: "Feld 1-1", spot: spots.first },
                 { name: "Feld 1-2", spot: spots.first },
                 { name: "Feld 2-1", spot: spots.last },
                 { name: "Feld 2-2", spot: spots.last }
               ])

  BULA_START = Time.new(2022, 7, 23, 9, 0)
  BULA_END = Time.new(2022, 8, 6, 12, 0)
  activities.each do |activity|
    4.times do
      FactoryBot.create(:activity_execution, amount_participants: activity.participants_count_activity,
                        starts_at: Faker::Time.between(from: BULA_START, to: BULA_END), activity: activity, field: Field.all.sample)
    end
  end

  FactoryBot.create(:fixed_event, starts_at: Orca::CAMP_START.change({ hour: 9, min: 0, sec: 0 }), title: 'Eröffnungsfeier')
  FactoryBot.create(:fixed_event, starts_at: Orca::CAMP_END.change({ hour: 9, min: 0, sec: 0 }), title: 'Abschlussfeier')
end
