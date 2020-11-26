# frozen_string_literal: true

class Leader < ApplicationRecord
  has_many :al_units, inverse_of: :al, class_name: 'Unit', foreign_key: 'al_id', dependent: :destroy
  has_many :lagerleiter_units, inverse_of: :lagerleiter, class_name: 'Unit', foreign_key: 'lagerleiter_id',
                               dependent: :destroy

  validates :email, presence: true
  validates :pbs_id, uniqueness: { allow_blank: true }
  validates :last_name, :first_name, :address, :zip_code, :town, presence: true, on: :complete
  belongs_to :user, optional: true, inverse_of: :leader, foreign_key: :email, primary_key: :email

  enum gender: { male: 'male', female: 'female' }
  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en' }

  def full_name
    [first_and_last_name, scout_name].join(' v/o ')
  end

  def first_and_last_name
    [first_name, last_name].join(' ')
  end

  def salutation_name
    [scout_name, first_name].first(&:present?)
  end

  def address_lines
    [
      full_name,
      address,
      [zip_code, town].join(' '),
      country
    ].flatten.compact.join("\n")
  end
end
