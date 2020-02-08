# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[openid_connect developer]

  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :uid, presence: true
  validates :pbs_id, presence: true, allow_blank: true

  def self.from_omniauth(auth)
    email = auth.info.email
    pbs_id = auth.info.pbs_id || auth.to_hash.dig('extra', 'raw_info', 'pbs_id')
    locale = auth.info.locale || auth.to_hash.dig('extra', 'raw_info', 'locale')

    find_or_create_by(uid: auth.uid, provider: auth.provider).tap do |user|
      user.email = email if email.present?
      user.pbs_id = pbs_id if pbs_id.present?
      user.save!
    end
  end
end
