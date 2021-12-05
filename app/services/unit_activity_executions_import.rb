# frozen_string_literal: true

class UnitActivityExecutionsImport
  attr_accessor :file, :errors, :imported

  def initialize(file)
    @file = file
    @errors = {}
    @imported = []
  end

  def default_options
    { csv: { header_converters: :downcase, headers: true, col_sep: ';' } }
  end

  def call
    parse_file(@file)
    imported.each_with_index do |record, index|
      record && (record.valid? || @errors[index] = record.errors.full_messages.join(', '))
    end
    @errors.none? && on_success
  end

  def parse(input = ARGF, **options)
    options.reverse_merge!(default_options)
    CSV.parse(input, **options.fetch(:csv)).each_with_index do |row, index|
      @imported << import_row(row, **options)
    rescue StandardError => e
      @errors[index] = e.message
    end
  end

  def parse_file(file, **options)
    parse(file.read.force_encoding('UTF-8'), **options)
  end

  private

  def on_success
    @imported.compact.each(&:save!)
    true
  end

  def on_error
    # imported_items.compact.each_with_index do |item, index|
    #   item.errors.full_messages.each do |msg|
    #     @errors.push "Row #{index + 2}: #{msg}"
    #   end
    # end
    # false
  end

  def import_row(row, **_options)
    UnitActivityExecution.new(
      unit_id: row['einheit'] || row[0],
      activity_execution_id: row['aktivitätsdurchführung'] || row[1],
      headcount: row['personen'] || row[4],
      additional_data: row.to_h
    )
  rescue StandardError => e
    @errors << "Row #{index}: Invalid values in row"
    Rollbar.warning e if Rollbar.configuration.enabled
  end
end
