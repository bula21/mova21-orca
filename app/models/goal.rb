# frozen_string_literal: true

class Goal < ApplicationRecord
  has_and_belongs_to_many :activities

  validates :name, presence: true
end
