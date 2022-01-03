# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhoneNumberHelper, type: :helper do
  describe '#seems_like_mobile_number?' do
    subject { helper.seems_like_mobile_number?(phone_number) }

    let(:phone_number) { nil }

    it { is_expected.to eq false }

    (5..9).each do |digit|
      context "when starts with 07#{digit}" do
        let(:phone_number) { "07#{digit}1232345" }

        it { is_expected.to eq true }
      end
    end

    context 'when has +41' do
      let(:phone_number) { '+41751232345' }

      it { is_expected.to eq true }
    end

    context 'when has 0041' do
      let(:phone_number) { '0041761232345' }

      it { is_expected.to eq true }
    end

    context 'when has spaces 0041 78' do
      let(:phone_number) { '0041 78 123 23 45' }

      it { is_expected.to eq true }
    end
  end
end
