# frozen_string_literal: true

require 'csv'

class ImportService
  def initialize
    Unit.transaction do
      timber_import
      tents_import
      lagerplatz_import
    end
  end

  private

  def tents_import
    tents = Checkpoint.find_by(slug: 'tents')
    CSV.foreach(Rails.root.join('app/services/data/zelte.csv'), headers: true, col_sep: ',') do |row|
      r = row.to_h
      unit = Unit.find(r['id'])
      CheckpointUnit.create!(unit: unit, checkpoint: tents, notes_check_in: check_in_text_tents(r))
    end
  end

  def lagerplatz_import
    Unit.all.each do |unit|
      CheckpointUnit.create!(unit: unit, checkpoint: 'lagerplatz_1',
                            check_in_by: User.find_by(email: 'aron.riegger@bula21.ch'), check_in_at: Time.zone.now)
    end
  end

  def timber_import
    timber = Checkpoint.find_by(slug: 'timber')
    CSV.foreach(Rails.root.join('app/services/data/bauholz.csv'), headers: true, col_sep: ',') do |row|
      r = row.to_h
      unit = Unit.find(r['id'])
      CheckpointUnit.create!(unit: unit, checkpoint: timber, notes_check_in: check_in_text_timber(r))
    end
  end

  def check_in_text_tents(row_hash)
    "#{row_hash.values.last}x Seilschaftszelte  / Tende di gruppo (dell'esercito) / Tentes de l'armée"
  end

  def check_in_text_timber(row_hash)
    "#{row_hash['rundholz 4m'].to_i}x 4m Rundholz / Pali tondi / Perches\n" \
      "#{row_hash['rundholz 6m'].to_i}x 6m Rundholz / Pali tondi / Perches\n" \
      "#{row_hash['rundholz 8m'].to_i}x 8m Rundholz / Pali tondi / Perches\n" \
      "#{row_hash['rundholz 10m'].to_i}x 10m Rundholz / Pali tondi / Perches\n" \
      "#{row_hash['rundholz 11m'].to_i}x 11m Rundholz / Pali tondi / Perches\n" \
      "#{row_hash['schwartenbund'].to_i}x Schwartenbund / Fascio di codighe / Couennaux\n" \
      "Kommentar / commento / commentaire: #{row_hash['kommentar'] || '-'}"
  end
end
