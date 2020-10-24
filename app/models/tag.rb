# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  icon       :string           not null
#  label      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  extend Mobility
  
  has_and_belongs_to_many :activities

  validates :code, :icon, :label, presence: true
  validates :code, uniqueness: true

  translates :label, type: :string, locale_accessors: true, fallbacks: true

  def to_s
    label
  end
end
