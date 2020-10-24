class TranslateLabelOfTags < ActiveRecord::Migration[6.0]
  def up
    rename_column :tags, :label, :label_untranslated
    add_column :tags, :label, :jsonb, default: {}

    Tag.all.find_each do |tag|
      tag.update(label_de: tag.label_untranslated)
    end
  end
end
