# frozen_string_literal: true

class Leader < ApplicationRecord
  has_many :al_units, inverse_of: :al, class_name: 'Unit', foreign_key: 'al_id'
  has_many :lagerleiter_units, inverse_of: :lagerleiter, class_name: 'Unit', foreign_key: 'lagerleiter_id'

  validates :email, presence: true
  validates_uniqueness_of :pbs_id, allow_blank: true
  validates :last_name, :first_name, :address, :zip_code, :town, :country, presence: true, on: :complete

  enum gender: { male: 'male', female: 'female' }
  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en' }

  def full_name
    "#{first_name} #{last_name} v/o #{scout_name}"
  end
end
