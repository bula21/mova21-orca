# frozen_string_literal: true

class UnitActivity < ApplicationRecord
  belongs_to :unit
  belongs_to :activity

  include RankedModel
  ranks :priority, with_same: :unit_id

  scope :prioritized, -> { rank(:priority) }

  validates :activity_id, uniqueness: { scope: :unit_id }
end
