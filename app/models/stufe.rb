# frozen_string_literal: true

class Stufe < ApplicationRecord
  extend Mobility

  has_and_belongs_to_many :activities
  has_and_belongs_to_many :activities_recommended, class_name: 'Activity'

  validates :name, presence: true

  translates :name, type: :string, locale_accessors: true, fallbacks: true
end
