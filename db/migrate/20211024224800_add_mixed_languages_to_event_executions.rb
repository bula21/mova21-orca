class AddMixedLanguagesToEventExecutions < ActiveRecord::Migration[6.0]
  def change
    add_column :activity_executions, :mixed_languages, :boolean
  end
end