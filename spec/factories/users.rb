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
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@bula.example" }
    pbs_id { nil }
    uid { email }
    provider { :test }
    leader { build(:leader, pbs_id: pbs_id, email: email) }

    trait :midata_user do
      sequence(:pbs_id) { |n| n }
      role_user { true }
    end

    trait :admin do
      role_admin { true }
    end
  end
end
