# frozen_string_literal: true

class RoverShiftsImport
  UKULA_TIME = /\w+,\s*(?<d>\d+)\.(?<m>\d+)\.\s+(?<H_start>\d+):(?<M_start>\d+)
                \s+-\s+(?<H_end>\d+):(?<M_end>\d+)/.freeze
  UKULA_YEAR = 2022
  require 'roo'

  attr_accessor :file, :errors

  def initialize(file:, job_id:)
    @file = file
    @errors = []
    @items = {}
    @job_id = job_id
  end

  def call
    delete_items
    import_items
    if @items.values.map(&:valid?).all?
      on_success
    else
      on_error
    end
  end

  private

  def on_success
    @items.values.each(&:save!)
    true
  end

  def on_error
    @items.compact.each_with_index do |item, index|
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

  def delete_items
    RoverShift.where(job_id: @job_id).destroy_all
  end

  def import_items
    spreadsheet = open_spreadsheet
    (2..spreadsheet.last_row).map do |i|
      row = spreadsheet.row(i)
      break if row[1..18].all?(&:blank?)

      build_rover_shift(row, i)
      assign_rovers(row)
    end
  end

  def build_rover_shift(row, _index)
    time = parse_time(row[1])
    shift_id = get_shift_id(row)
    @items[shift_id] ||= RoverShift.find_or_initialize_by(id: shift_id).tap do |rover_shift|
      rover_shift.assign_attributes(job_id: row[17].to_i, starts_at: time&.begin, ends_at: time&.end)
      rover_shift.rovers = []
    end
  end

  def get_shift_id(row)
    row[15].to_i
  end

  def assign_rovers(row)
    @items[get_shift_id(row)].rovers << row[16].to_i
  end

  def parse_time(ugly_ukula_string)
    time_match = ugly_ukula_string.match(UKULA_TIME)
    return unless time_match

    starts_at = Time.zone.local(UKULA_YEAR, time_match[:m], time_match[:d], time_match[:H_start], time_match[:M_start])
    ends_at = Time.zone.local(UKULA_YEAR, time_match[:m], time_match[:d], time_match[:H_end], time_match[:M_end])
    ends_at += 1.day if starts_at > ends_at

    starts_at..ends_at
  end
end
