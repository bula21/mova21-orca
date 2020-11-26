# frozen_string_literal: true

class ActivityCategory < ApplicationRecord
  extend Mobility
  has_ancestry

  scope :without_self, ->(id) { where.not(id: id) }

  validates :label, presence: true
  translates :label, type: :string, locale_accessors: true, fallbacks: true

  def full_label
    if parent_id
      "#{label} (#{parent.label})"
    else
      label
    end
  end
end
