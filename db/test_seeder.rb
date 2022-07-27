require 'active_record'
require 'factory_bot'
# Instructions for seeding the database with test data
# 1. add the units.json file to the db/test_data directory: https://url_to_orca/units.json
# 2. copy all files from https://bula21.sharepoint.com/:u:/r/Freigegebene%20Dokumente/A_Ressorts_Commissions/07_Support/3d_IT/Orca/test_data.zip?csf=1&web=1&e=oikfjD
# 3. run this script
#
class TestSeeder
  def seed
    truncate_and_execute_file('kvs')
    import_units('db/test_data/units.json')
    truncate_and_execute_file('stufen')
    truncate_and_execute_file('spots')
    truncate_and_execute_file('fields')
    truncate_and_execute_file('tags')
    truncate_and_execute_file('goals')
    truncate_and_execute_file('activity_categories')
    truncate_and_execute_file('activities')
    truncate_and_execute_file('activities_goals')
    truncate_and_execute_file('activities_stufen')
    truncate_and_execute_file('activities_stufen_recommended')
    truncate_and_execute_file('activities_tags')
    truncate_and_execute_file('activity_executions')
    truncate_and_execute_file('unit_activity_executions')
  end

  private

  def import_units(units_json_file)
    puts "Importing units from #{units_json_file}"
    units_json = File.read(units_json_file)
    units = JSON.parse(units_json)
    all_kvs = Kv.all
    units.each do |unit|
      Unit.create!(title: "Einheit ##{unit['id']}", lagerleiter: FactoryBot.build(:leader), kv: all_kvs.sample, al: FactoryBot.build(:leader), **unit.except('district_nr', 'week_nr', 'expected_participant_counts', 'participant_role_counts'))
    end
  end

  def execute_sql_file(path)
    IO.read(path).split("\n").reject { |l| l.starts_with? '--' }.reject(&:blank?).each do |statement|
      ActiveRecord::Base.connection.execute(statement) rescue byebug
    end
  end

  def truncate_and_execute_file(name)
    execute_sql_file("db/test_data/#{name}.sql")
    ActiveRecord::Base.connection.reset_pk_sequence!(name)
  end
end

