# frozen_string_literal: true

class Field < ApplicationRecord
  extend Mobility

  belongs_to :spot, inverse_of: :fields
  has_many :activity_executions, dependent: :nullify, inverse_of: :field
  translates :name, type: :string, locale_accessors: true, fallbacks: true

  def to_s
    "#{spot}: #{name}"
  end
end
