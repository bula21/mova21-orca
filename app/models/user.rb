# frozen_string_literal: true

class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[openid_connect developer]

  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :uid, presence: true

  def self.from_omniauth(auth)
    find_or_create_by(uid: auth.uid) do |user|
      user.email = auth.info.email
      user.provider = auth.provider
    end
  end

  def midata_user?
    provider == 'midata'
  end
end
