# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


al = FactoryBot.create(:leader, scout_name: 'Lego')
lagerleiter = FactoryBot.create(:leader, scout_name: 'Duplo', phone_number: '+41 79 123 45 67', email: 'duplo@example.ch')
FactoryBot.create(:unit, title: 'Sommerlager Pfadistufe', stufe: 'wolf', abteilung: 'Pfadi H2O',
                  al: al, lagerleiter: lagerleiter)
FactoryBot.create(:unit, title: 'Sommerlager Wolfsstufe', stufe: 'pfadi', abteilung: 'Pfadi H2O',
                  al: al, lagerleiter: lagerleiter)
