# frozen_string_literal: true

# == Schema Information
#
# Table name: transport_locations
#
#  id               :bigint           not null, primary key
#  max_participants :integer
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe TransportLocation, type: :model do
  subject(:transport_location) { described_class.new(params) }

  let(:params) { attributes_for :transport_location }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:max_participants) }
end
