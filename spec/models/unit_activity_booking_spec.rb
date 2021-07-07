# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitActivityBooking, type: :model do
  subject(:activity_booking) { unit.activity_booking }

  let(:unit) { create(:unit) }

  describe '#all_comply?' do
    it { is_expected.not_to be_all_comply }
  end
end
