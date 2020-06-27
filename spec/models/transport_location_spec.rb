# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransportLocation, type: :model do
  subject(:transport_location) { described_class.new(params) }

  let(:params) { attributes_for :transport_location }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:max_participants) }
end
