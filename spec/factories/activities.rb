# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id                           :bigint           not null, primary key
#  activity_type                :string
#  block_type                   :string
#  description                  :jsonb
#  duration_activity            :integer
#  duration_journey             :integer
#  label                        :jsonb
#  language                     :string           not null
#  location                     :string
#  min_participants             :integer
#  participants_count_activity  :integer
#  participants_count_transport :integer
#  simo                         :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  transport_location_id        :bigint
#
# Indexes
#
#  index_activities_on_transport_location_id  (transport_location_id)
#
# Foreign Keys
#
#  fk_rails_...  (transport_location_id => transport_locations.id)
#
FactoryBot.define do
  factory :activity do
    activity_category { ActivityCategory.all.count > 3 ? ActivityCategory.all.sample : create(:activity_category) }
    activity_type { Activity.activity_types.values.sample }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
    language_flags { (1..8).to_a.sample }
    block_type { Activity.block_types.keys.sample }
    simo { Activity.simos.keys.sample }
    participants_count_activity { (12..128).to_a.sample }
    participants_count_transport { (12..128).to_a.sample }
    duration_activity { "0#{(0..4).to_a.sample}:#{(10..60).to_a.sample}" }
    duration_journey { (0..60).to_a.sample }
    location { Faker::Address.city }
    stufen { Stufe.all.count > 2 ? Stufe.all.sample(2) : create_list(:stufe, 2) }
    stufe_recommended { [stufen.sample] }
    sequence(:label_de) { |i| "#{stufen.sample.name_de} Aktivität ##{i}" }
  end
end
