# frozen_string_literal: true

# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  birthdate  :date
#  first_name :string
#  gender     :string
#  last_name  :string
#  scout_name :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pbs_id     :integer
#  unit_id    :bigint           not null
#
# Indexes
#
#  index_participants_on_unit_id  (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (unit_id => units.id)
#
class Participant < ApplicationRecord
  has_many :participant_units, inverse_of: :participant, dependent: :destroy
  has_many :units, through: :participant_units, dependent: :nullify

  validates :pbs_id, uniqueness: { allow_blank: true }
  validates :full_name, :birthdate, :gender, presence: true, on: :complete
  scope :from_midata, -> { where.not(pbs_id: nil) }
  scope :non_midata, -> { where(pbs_id: nil) }
  scope :national, -> { where(guest_troop: nil) }

  enum gender: { male: 'male', female: 'female' }

  def full_name
    [first_and_last_name, scout_name.presence].compact.join(' v/o ')
  end

  def complete?
    valid?(:complete)
  end

  def first_and_last_name
    [first_name, last_name].compact.join(' ')
  end
end
