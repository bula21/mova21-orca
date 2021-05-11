# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitActivityBooking, type: :model do
  subject(:activity_booking) { unit.activity_booking }

  let(:unit) { create(:unit) }

  before do
    allow(FeatureToggle).to receive(:enabled?).with(:unit_activity_booking).and_return(false)
  end

  describe '#open?' do
    it { is_expected.not_to be_open }
  end

  describe '#complete?' do
    it { is_expected.not_to be_complete }
  end
end
