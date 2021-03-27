# frozen_string_literal: true

class UnitActivity < ApplicationRecord
  belongs_to :unit
  belongs_to :activity

  include RankedModel
  ranks :priority, with_same: :unit_id

  scope :prioritized, -> { rank(:priority) }
end
