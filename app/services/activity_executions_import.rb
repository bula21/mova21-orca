# frozen_string_literal: true

class ActivityExecutionsImport
  require 'roo'

  attr_accessor :file, :errors

  def initialize(file, activity)
    @file = file
    @activity = activity
    @errors = []
    @imported_items_count = 0
  end

  def call
    if imported_items.compact.map(&:valid?).all?
      on_success
    else
      on_error
    end
  end

  attr_reader :imported_items_count

  private

  def on_success
    imported_items.each(&:save!)
    @imported_items_count = imported_items.count
    true
  end

  def on_error
    imported_items.compact.each_with_index do |item, index|
      item.errors.full_messages.each do |msg|
        @errors.push "Row #{index + 2}: #{msg}"
      end
    end
    false
  end

  def open_spreadsheet
    case File.extname(file.original_filename)
    when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
    when '.xlsx' then Roo::Excelx.new(file.path)
    else raise TypeError, "Unknown file type: #{file.original_filename}"
    end
  end

  def load_imported_items
    spreadsheet = open_spreadsheet
    (2..spreadsheet.last_row).map do |i|
      row = spreadsheet.row(i)
      break if row[1..7].all?(&:blank?)

      build_activity_execution(row, i)
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_activity_execution(row, index)
    @activity.activity_executions.build(
      starts_at: time_in_swiss_timezone(row[0]),
      ends_at: time_in_swiss_timezone(row[1]),
      amount_participants: row[2],
      transport: row[6] == 'ja',
      mixed_languages: row[7] == 'ja',
      field: Field.includes(:spot).find_by(name: row[4], spots: { name: row[3] }),
      transport_ids: row[8],
      **language_flags(row[5].split(',').map(&:strip))
    )
  rescue StandardError => e
    @errors.push "Row #{index + 2}: Invalid values in row"
    Rollbar.warning e if Rollbar.configuration.enabled
  end

  def time_in_swiss_timezone(date_time)
    ActiveSupport::TimeZone['Europe/Zurich'].parse(date_time.to_s(:long))
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def imported_items
    @imported_items ||= load_imported_items
  end

  def language_flags(languages)
    languages.each_with_object({}) { |c, r| r["language_#{c}".to_sym] = true; }
  end
end
