class CreateParticipantSearchLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :participant_search_logs do |t|
      t.references :searcher, foreign_key: { to_table: :users }
      t.text :search_query
      t.timestamps
    end
  end
end
