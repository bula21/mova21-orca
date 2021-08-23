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
    if imported_items.map(&:valid?).all?
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
    imported_items.each_with_index do |item, index|
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

      build_activity_execution(row)
    end
  end

  def build_activity_execution(row)
    @activity.activity_executions.build(
      starts_at: row[0],
      ends_at: row[1],
      amount_participants: row[2],
      field: Field.includes(:spot).find_by(name: row[4], spots: { name: row[3] }),
      **language_flags(row[5].split(',').map(&:strip)),
      transport: row[6] == 'ja'
    )
  end

  def imported_items
    @imported_items ||= load_imported_items
  end

  def language_flags(languages)
    languages.each_with_object({}) { |c, r| r["language_#{c}".to_sym] = true; }
  end
end
