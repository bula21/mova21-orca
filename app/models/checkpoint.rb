# frozen_string_literal: true

class Checkpoint < ApplicationRecord
  has_many :checkpoint_units
  has_many :units, through: :checkpoint_units
  belongs_to :depends_on_checkpoint, class_name: 'Checkpoint', optional: true
  has_many :dependant_checkpoints, class_name: 'Checkpoint', foreign_key: :depends_on_checkpoint_id,
                                   inverse_of: :depends_on_checkpoint

  scope :without_dependencies, -> { where(depends_on_checkpoint_id: nil) }

  extend Mobility
  translates :title, locale_accessors: true, fallbacks: true
  translates :description_check_in, locale_accessors: true, fallbacks: true
  translates :description_check_out, locale_accessors: true, fallbacks: true
end
