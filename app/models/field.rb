# frozen_string_literal: true

class Field < ApplicationRecord
  belongs_to :spot, inverse_of: :fields
  has_many :activity_executions, dependent: :nullify
end
