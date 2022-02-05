# frozen_string_literal: true

class Field < ApplicationRecord
  belongs_to :spot, inverse_of: :fields
  has_many :activity_executions, dependent: :nullify

  def to_s
    "#{spot}: #{name}"
  end
end
