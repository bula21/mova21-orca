class SeedActivityCategory < ActiveRecord::Migration[6.0]
  def change
    ActivityCategory.reset_column_information
    f = ActivityCategory.create(label_de: 'Frohnarbeit', label_fr: 'Frohnarbeit', label_en: 'Frohnarbeit', label_it: 'Frohnarbeit')
    ActivityCategory.create(label_de: 'Frohnarbeit', label_fr: 'Frohnarbeit', label_en: 'Frohnarbeit', label_it: 'Frohnarbeit', parent: f, code: 'frohnarbeit')
    v = ActivityCategory.create(label_de: 'Village Global', label_fr: 'Village Global', label_en: 'Village Global', label_it: 'Village Global')
    ActivityCategory.create(label_de: 'Village Global', label_fr: 'Village Global', label_en: 'Village Global', label_it: 'Village Global', parent: v, code: 'village_global')
    ak = ActivityCategory.create(label_de: 'Aktivität', label_fr: 'Aktivität', label_en: 'Aktivität', label_it: 'Aktivität')
    ActivityCategory.create(label_de: 'Aktivität', label_fr: 'Aktivität', label_en: 'Aktivität', label_it: 'Aktivität', parent: ak, code: 'activity')
    au = ActivityCategory.create(label_de: 'Ausflug', label_fr: 'Ausflug', label_en: 'Ausflug', label_it: 'Ausflug')
    ActivityCategory.create(label_de: 'Ausflug', label_fr: 'Ausflug', label_en: 'Ausflug', label_it: 'Ausflug', code: 'excursion', parent: au)
    ActivityCategory.create(label_de: 'Wasser', label_fr: 'Wasser', label_en: 'Wasser', label_it: 'Wasser', code: 'excursion', parent: au)

    Activity.all.each do |a|
      a.activity_category = ActivityCategory.where(code: a.activity_type).first
      a.save
    end
  end
end
