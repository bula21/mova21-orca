# frozen_string_literal: true

class Spot < ApplicationRecord
  has_many :fields, -> { order('LOWER(fields.name), fields.name') }, inverse_of: :spot, dependent: :destroy

  def to_s
    name
  end
end
