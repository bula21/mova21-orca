class CreateCheckpoints < ActiveRecord::Migration[6.1]
  def change
    create_table :checkpoints do |t|
      t.string :slug, null: false, unique: true
      t.json :title, default: {}
      t.json :description_check_in, default: {}
      t.json :description_check_out, default: {}
      t.references :depends_on_checkpoint, foreign_key: { to_table: :checkpoints }

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Checkpoint.create(slug: 'tents', title_de: 'Zelte')
        Checkpoint.create(slug: 'timber', title_de: 'Rundholz')
        lagerplatz_1 = Checkpoint.create(slug: 'lagerplatz_1', title_de: 'Lagerplatz  Kontrolle #1')
        Checkpoint.create(slug: 'lagerplatz_2', title_de: 'Lagerplatz Kontrolle #2', depends_on_checkpoint: lagerplatz_1)
      end
    end
  end
end
