# frozen_string_literal: true

class User < ApplicationRecord
  include Bitfields
  devise :omniauthable, omniauth_providers: %i[openid_connect developer]

  has_one :leader, foreign_key: :email, primary_key: :email, inverse_of: :user, dependent: nil

  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :uid, presence: true
  validates :pbs_id, presence: true, allow_blank: true

  bitfield :role_flags, :role_user, :role_admin, :role_programm, :role_tn_administration

  def self.from_omniauth(auth)
    email = auth.info.email
    # locale = auth.info.locale || auth.to_hash.dig('extra', 'raw_info', 'locale')
    pbs_id = auth.info.pbs_id || auth.to_h.dig('extra', 'raw_info', 'pbs_id')

    find_or_create_by(uid: auth.uid, provider: auth.provider).tap do |user|
      user.email = email
      user.pbs_id = pbs_id unless pbs_id.to_i.zero?
      user.save!
    end
  end

  def midata_user?
    pbs_id.present? && !pbs_id.zero?
  end
end
