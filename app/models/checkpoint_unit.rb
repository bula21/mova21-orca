# frozen_string_literal: true

class CheckpointUnit < ApplicationRecord
  has_paper_trail

  belongs_to :checkpoint
  belongs_to :unit, inverse_of: :checkpoints
  belongs_to :check_in_by, class_name: 'User', optional: true
  belongs_to :check_out_by, class_name: 'User', optional: true
  belongs_to :confirmed_check_in_by, class_name: 'User', optional: true
  belongs_to :confirmed_check_out_by, class_name: 'User', optional: true
  has_one :depends_on_checkpoint, through: :checkpoint
  has_many :dependant_checkpoints, through: :checkpoint

  validates :checkpoint, uniqueness: { scope: :unit, message: I18n.t('checkpoints.already_checked_in') }
  validates :cost_in_chf, numericality: { greater_than: 0 }, allow_nil: true
  scope :without_dependencies, -> { joins(:checkpoint).where(checkpoint: { depends_on_checkpoint_id: nil }) }

  scope :as_array_where_checked_in, -> { filter(&:confirmed_check_in?) }

  def confirmed_check_in?
    confirmed_checked_in_at.present? || checked_in_on_paper
  end

  def confirmed_check_out?
    confirmed_checked_out_at.present? || checked_out_on_paper
  end

  def check_out_blocked_by_dependency?
    depends_on_checkpoint.present? &&
      !CheckpointUnit.find_by(unit: unit, checkpoint: depends_on_checkpoint).confirmed_check_out?
  end
end
