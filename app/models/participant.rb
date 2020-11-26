# frozen_string_literal: true

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
