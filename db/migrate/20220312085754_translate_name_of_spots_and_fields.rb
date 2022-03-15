class TranslateNameOfSpotsAndFields < ActiveRecord::Migration[6.0]
  def change
    rename_column :spots, :name, :name_untranslated
    add_column :spots, :name, :jsonb, default: {}

    rename_column :fields, :name, :name_untranslated
    add_column :fields, :name, :jsonb, default: {}

    Spot.all.find_each do |spot|
      spot.update(name_de: spot.name_untranslated)
    end

    Field.all.find_each do |field|
      field.update(name_de: field.name_untranslated)
    end
  end
end
