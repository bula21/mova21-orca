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
  has_and_belongs_to_many :activities_recommended, class_name: 'Activity'

  validates :name, presence: true

  translates :name, type: :string, locale_accessors: true, fallbacks: true
end
