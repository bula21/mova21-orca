# frozen_string_literal: true

class Participant < ApplicationRecord
  belongs_to :unit

  validates_uniqueness_of :pbs_id, allow_blank: true

  enum gender: { male: 'male', female: 'female' }

  def full_name
    "#{first_name} #{last_name} v/o #{scout_name}"
  end

  def first_and_last_name
    "#{first_name} #{last_name}"
  end
end
