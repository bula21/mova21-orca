require 'rails_helper'

RSpec.describe ActivityBooking, type: :model do
  let(:unit) { create(:unit) }
  subject(:activity_booking) { unit.activity_booking }

  describe '#open?' do
    it { is_expected.not_to be_open }
  end

  describe '#complete?' do
    it { is_expected.not_to be_complete }
  end
end
