# frozen_string_literal: true

class TransportLocation < ApplicationRecord
  has_and_belongs_to_many :activities

  validates :name, :max_participants, presence: true

  def to_s
    "#{name} (max. #{max_participants})"
  end
end
