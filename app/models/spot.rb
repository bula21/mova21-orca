# frozen_string_literal: true

class Spot < ApplicationRecord
  has_many :fields, -> { order('LOWER(fields.name), fields.name') }, dependent: :destroy, inverse_of: :spot
end
