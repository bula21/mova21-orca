class AddLanguageToUnits < ActiveRecord::Migration[6.0]
  def up
    add_column :units, :language, :string, null: true

    Unit.find_each do |camp_unit|
      camp_unit.language ||= camp_unit.kv&.locale
      camp_unit.save
    end
  end
end
