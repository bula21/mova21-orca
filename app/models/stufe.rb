# frozen_string_literal: true

# == Schema Information
#
# Table name: stufen
#
#  id         :bigint           not null, primary key
#  name       :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Stufe < ApplicationRecord
  extend Mobility

  has_and_belongs_to_many :activities
  has_and_belongs_to_many :fixed_events
  has_and_belongs_to_many :activities_recommended, class_name: 'Activity'
  # has_many :units, inverse_of: :stufe

  validates :name, presence: true
  delegate :to_s, :to_sym, to: :code

  translates :name, locale_accessors: true, fallbacks: true
end
