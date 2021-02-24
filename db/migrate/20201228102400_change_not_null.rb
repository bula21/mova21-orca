class ChangeNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tags, :label_untranslated, true
  end
end
