class MoveKvIdsToModel < ActiveRecord::Migration[6.0]
  def up
    create_table :kvs do |t|
      t.string :name, null: false
      t.integer :pbs_id, null: false
      t.string :locale, null: false

      t.index :pbs_id, unique: true
    end
    add_foreign_key :units, :kvs, validate: false, column: :kv_id, primary_key: :pbs_id


    if midata_test_environment?
      Kv.create(
          [
              { pbs_id: 234, name: 'AS Genevois', locale: :fr },
              { pbs_id: 397, name: 'AS Jurassienne', locale: :fr },
              { pbs_id: 391, name: 'AS Valaisan', locale: :fr },
              { pbs_id: 57, name: 'Battasendas Grischun', locale: :de },
              { pbs_id: 400, name: 'Pfadi Aargau', locale: :de },
              { pbs_id: 425, name: 'Pfadi Glarus', locale: :de },
              { pbs_id: 2, name: 'Pfadi Kanton Bern', locale: :de },
              { pbs_id: 49, name: 'Pfadi Kanton Luzern', locale: :de },
              { pbs_id: 426, name: 'Pfadi Kanton Schwyz', locale: :de },
              { pbs_id: 428, name: 'Pfadi Kanton Solothurn', locale: :de },
              { pbs_id: 424, name: 'Pfadi Kanton Zug', locale: :de },
              { pbs_id: 205, name: 'Pfadi Kantonalverband Schaffhausen', locale: :de },
              { pbs_id: 429, name: 'Pfadi Region Basel', locale: :de },
              { pbs_id: 64, name: 'Pfadi St. Gallen – Appenzell', locale: :de },
              { pbs_id: 80, name: 'Pfadi Thurgau', locale: :de },
              { pbs_id: 166, name: 'Pfadi Unterwalden', locale: :de },
              { pbs_id: 427, name: 'Pfadi Uri', locale: :de },
              { pbs_id: 3, name: 'Pfadi Züri', locale: :de },
              { pbs_id: 423, name: 'Scoutismo Ticino', locale: :it },
              { pbs_id: 70, name: 'Scouts Fribourgeois', locale: :de },
              { pbs_id: 156, name: 'Scouts Neuchâtelois', locale: :fr },
              { pbs_id: 4, name: 'Scouts Vaudois', locale: :fr }
          ]
      )
    else
      Kv.create(
          [
              { pbs_id: 166, name: 'Pfadi St. Gallen - Appenzell', locale: :de },
              { pbs_id: 638, name: 'AS Fribourgeois', locale: :fr },
              { pbs_id: 1018, name: 'AS Genevois', locale: :fr },
              { pbs_id: 911, name: 'AS Jurassienne', locale: :fr },
              { pbs_id: 994, name: 'AS Valaisan', locale: :fr },
              { pbs_id: 3, name: 'Pfadi Kanton Solothurn', locale: :de },
              { pbs_id: 4, name: 'Pfadi Kanton Bern', locale: :de },
              { pbs_id: 85, name: 'Pfadi Uri', locale: :de },
              { pbs_id: 142, name: 'Pfadi Kanton Schwyz', locale: :de },
              { pbs_id: 161, name: 'Pfadi Glarus', locale: :de },
              { pbs_id: 167, name: 'Battasendas Grischun', locale: :de },
              { pbs_id: 4691, name: 'Pfadi Aargau', locale: :de },
              { pbs_id: 631, name: 'Pfadi Kanton Schaffhausen', locale: :de },
              { pbs_id: 237, name: 'Pfadi Kanton Zug', locale: :de },
              { pbs_id: 179, name: 'Pfadi Luzern', locale: :de },
              { pbs_id: 299, name: 'Pfadi Region Basel', locale: :de },
              { pbs_id: 993, name: 'Pfadi Thurgau', locale: :de },
              { pbs_id: 187, name: 'Pfadi Unterwalden', locale: :de },
              { pbs_id: 238, name: 'Scoutismo Ticino', locale: :it },
              { pbs_id: 880, name: 'Scouts Neuchatelois', locale: :fr },
              { pbs_id: 513, name: 'Scouts Vaudois', locale: :fr },
              { pbs_id: 1145, name: 'Pfadi Zueri', locale: :de }
          ]
      )
    end
  end

  def down
    remove_foreign_key :units, :kvs, column: :kv_id

    drop_table :kvs
  end

  def midata_test_environment?
    ENV['MIDATA_BASE_URL']&.include?('pbs.puzzle.ch')
  end
end
