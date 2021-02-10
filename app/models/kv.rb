# frozen_string_literal: true

class Kv < ApplicationRecord
  has_many :units, inverse_of: :kv, dependent: :destroy
end
