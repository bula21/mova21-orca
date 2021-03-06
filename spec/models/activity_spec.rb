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
require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe '::bookable_by' do
    let(:unit) { create(:unit) }
    let(:activity) { create(:activity) }

    it do
      # binding.pry
    end
  end
end
