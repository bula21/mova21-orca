# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '::from_omniauth' do
    subject(:authenticated_user) { described_class.from_omniauth(auth) }

    let(:auth) { double }
    let(:auth_info) { double }

    context 'with existing user' do
      let(:user) { create(:user) }

      before do
        allow(auth).to receive(:uid).and_return(user.uid)
      end

      it { is_expected.to eq(user) }
    end

    context 'with new user' do
      let(:user) { build(:user) }

      before do
        allow(auth).to receive(:uid).and_return(user.uid)
        allow(auth).to receive(:info).and_return(auth_info)
        allow(auth).to receive(:provider).at_least(:once).and_return('test')
        allow(auth_info).to receive(:email).and_return(user.email)
      end

      it do
        expect(authenticated_user).to be_persisted
        expect(authenticated_user.email).to eq(user.email)
      end
    end
  end

  describe 'midata_user?' do
    subject { user.midata_user? }

    let(:user) { build(:user, :midata) }

    it { is_expected.to be true }

    context 'when is not a midata user' do
      let(:user) { build(:user) }

      it { is_expected.to be false }
    end
  end
end
