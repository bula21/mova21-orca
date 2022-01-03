# frozen_string_literal: true

class FixedEventBlueprint < Blueprinter::Base
  identifier :id

  fields :title
  field :starts_at, datetime_format: ->(datetime) { datetime.nil? ? datetime : datetime.iso8601 }
  field :ends_at, datetime_format: ->(datetime) { datetime.nil? ? datetime : datetime.iso8601 }
end
