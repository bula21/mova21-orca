class AddTranslatedNameToGoals < ActiveRecord::Migration[6.0]
  def change
    rename_column :goals, :name, :old_name_de
    add_column :goals, :name, :jsonb, default: {}

    goal_translations = [{
                           'de' => 'Pfadi (er) leben',
                           'it' => 'Vivere lo scoutismo',
                           'fr' => 'Vivre le scoutisme'
                         }, {
                           'de' => 'Diversität und Inklusion',
                           'it' => 'Diversità e Inclusione',
                           'fr' => 'Diversité et inclusion',
                         }, {
                           'de' => 'Umwelt',
                           'it' => 'Ambiente',
                           'fr' => 'Environnement',
                         }, {
                           'de' => 'Prävention',
                           'it' => 'Prevenzione',
                           'fr' => 'Prévention',
                         }, {
                           'de' => 'Dimension und Austausch',
                           'it' => 'Scambio e Dimensione',
                           'fr' => 'Dimension et échange',
                         }]

    goal_translations.each do |goal_translation|
      Goal.find_by(old_name_de: goal_translation['de']).update(name_it: goal_translation['it'],
                                                           name_fr: goal_translation['fr'],
                                                           name_de: goal_translation['de'])
    end
    remove_column :goals, :old_name_de, :string
  end
end
