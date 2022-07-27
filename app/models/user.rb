# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  email      :string           default(""), not null
#  provider   :string
#  role_flags :integer          default(0)
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pbs_id     :integer
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_uid    (uid) UNIQUE
#
class User < ApplicationRecord
  ROLES = %i[user admin programm tn_administration editor allocation read_unit unit_communication
             checkin_checkout checkin_checkout_manager tn_reader participant_searcher read_allocation].freeze

  include Bitfields
  devise :omniauthable, omniauth_providers: %i[openid_connect developer]

  has_one :leader, foreign_key: :email, primary_key: :email, inverse_of: :user, dependent: nil
  has_many :participant_search_logs, dependent: :destroy

  validates :email, presence: true, format: { with: Devise.email_regexp }
  validates :uid, presence: true
  validates :pbs_id, presence: true, allow_blank: true

  bitfield :role_flags, *ROLES.map { "role_#{_1}".to_sym }

  def self.from_omniauth(auth)
    find_or_create_by(uid: auth.uid, provider: auth.provider).tap do |user|
      user.populate_info_from_omniauth!(auth)
    end
  end

  def full_name
    if leader.present?
      leader.full_name
    else
      email
    end
  end

  # rubocop:disable Metrics/AbcSize
  def populate_info_from_omniauth!(auth)
    pbs_id = auth.info.pbs_id || auth.to_h&.dig('extra', 'raw_info', 'pbs_id')

    self.email = auth.info.email
    # self.locale = auth.info.locale || auth.to_hash.dig('extra', 'raw_info', 'locale')
    self.pbs_id = pbs_id unless pbs_id.to_i.zero?
    self.roles = auth.to_hash&.dig('extra', 'raw_info', 'orca', 'roles') if ENV['OIDC_ISSUER'].present?
    save!
  end
  # rubocop:enable Metrics/AbcSize

  def roles=(*value)
    value = Array.wrap(value).flatten.compact.map(&:to_sym)
    ROLES.each { |role| try("role_#{role}=", value.include?(role.to_sym)) }
  end

  def roles
    ROLES.filter { |role| try("role_#{role}?") }
  end

  def midata_user?
    pbs_id.present? && !pbs_id.zero?
  end
end
