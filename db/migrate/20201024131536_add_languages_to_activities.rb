class AddLanguagesToActivities < ActiveRecord::Migration[6.0]
  def change
    add_column :activities, :language_flags, :int, default: nil, null: true

    reversible do |direction|
      direction.up do 
        next unless defined?(Activity)

        Activity.find_each do |activity|
          mixed = activity.language == 'mixed'
          activity.language_de = activity.language == 'de' || mixed
          activity.language_fr = activity.language == 'fr' || mixed
          activity.language_it = activity.language == 'it' || mixed
          activity.language_en = activity.language == 'en' || mixed
          activity.save!
        end
      end
    end

    remove_column :activities, :language, :string, null: false 
  end
end
