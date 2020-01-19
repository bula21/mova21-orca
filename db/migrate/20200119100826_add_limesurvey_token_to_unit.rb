class AddLimesurveyTokenToUnit < ActiveRecord::Migration[6.0]
  def change
    add_column :units, :limesurvey_token, :string
  end
end
