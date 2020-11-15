# frozen_string_literal: true

class Tag < ApplicationRecord
  has_and_belongs_to_many :activities

  validates :code, :icon, :label, presence: true
  validates :code, uniqueness: true

  def to_s
    label
  end
end
