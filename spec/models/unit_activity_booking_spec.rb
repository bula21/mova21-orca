# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitActivityBooking, type: :model do
  subject(:activity_booking) { unit.activity_booking }

  let(:unit) { create(:unit) }

  describe '#open?' do
    it { is_expected.not_to be_open }
  end

  describe '#complete?' do
    it { is_expected.not_to be_complete }
  end
end
