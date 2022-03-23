# frozen_string_literal: true

class ActivityCategory < ApplicationRecord
  extend Mobility
  has_ancestry

  scope :without_self, ->(id) { where.not(id: id) }

  validates :label, presence: true
  translates :label, locale_accessors: true, fallbacks: true

  def full_label
    if parent_id
      "#{label} (#{parent.label})"
    else
      label
    end
  end

  def to_s
    label
  end

  def css_code
    code || parent&.code
  end
end
