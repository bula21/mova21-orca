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
  belongs_to :unit

  validates :pbs_id, uniqueness: { allow_blank: true }

  enum gender: { male: 'male', female: 'female' }

  def full_name
    [first_and_last_name, scout_name].join(' v/o ')
  end

  def first_and_last_name
    [first_name, last_name].join(' ')
  end
end
