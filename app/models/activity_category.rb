# frozen_string_literal: true

class ActivityCategory < ApplicationRecord
  extend Mobility

  # has_and_belongs_to_many :activities
  belongs_to :parent, class_name: 'ActivityCategory', optional: true

  validates :name, presence: true
  translates :name, type: :string, locale_accessors: true, fallbacks: true

end
