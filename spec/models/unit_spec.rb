# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe 'complete?' do
    subject { unit.complete? }

    let(:unit) { build(:unit) }

    it { is_expected.to be true }

    context 'when is not complete' do
      let(:unit) { build(:unit, kv_id: nil) }

      it { is_expected.to be false }
    end
  end
end
