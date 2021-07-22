# frozen_string_literal: true

class Spot < ApplicationRecord
  has_many :fields, dependent: :destroy
end
