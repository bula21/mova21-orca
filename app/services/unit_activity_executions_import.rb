# frozen_string_literal: true

# require 'factory_bot'
class UnitActivityExecutionsImport
  attr_accessor :file, :errors, :imported

  def initialize(file:, delete_first: false)
    @delete_first = delete_first
    @file = file
    @errors = {}
    @imported = []
  end

  def default_options
    { csv: { header_converters: :downcase, headers: true, col_sep: ',' } }
  end

  def call
    UnitActivityExecution.transaction do
      UnitActivityExecution.destroy_all if @delete_first
      parse_file(@file)
      imported.each_with_index do |record, index|
        record && (record.valid? || @errors[index] = record.errors.full_messages.join(', '))
      end
      raise ActiveRecord::Rollback if @errors.any?

      on_success
    end
  end

  def parse(input = ARGF, **options)
    options.reverse_merge!(default_options)
    CSV.parse(input, **options.fetch(:csv)).each_with_index do |row, _index|
      @imported << import_row(row, **options)
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
    unit_id = row['einheit'] || row[0]
    activity_execution_id = row['aktivitätsdurchführung'] || row[1]

    # FactoryBot.create(:unit, id: unit_id) unless Unit.exists?(unit_id)
    # FactoryBot.create(:activity_execution, id: activity_execution_id, activity: Activity.all.sample)
    # unless ActivityExecution.exists?(activity_execution_id)

    UnitActivityExecution.create!(
      unit_id: unit_id,
      activity_execution_id: activity_execution_id,
      headcount: row['personen'] || row[8],
      additional_data: row.to_h
    )
  end
end
