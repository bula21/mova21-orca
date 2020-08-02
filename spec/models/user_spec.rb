# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, :midata_user) }

  describe '::from_omniauth' do
    subject(:authenticated_user) { described_class.from_omniauth(auth) }

    context 'with existing user' do
      let(:auth) do
        OpenStruct.new(
          uid: user.uid,
          provider: user.provider,
          info: OpenStruct.new(email: user.email, locale: 'en', pbs_id: user.pbs_id)
        )
      end

      it { is_expected.to eq(user) }
    end

    context 'with new user' do
      let(:keycloak_user) { build(:user, :midata_user) }
      let(:auth) do
        OpenStruct.new(
          uid: keycloak_user.uid,
          provider: keycloak_user.provider,
          info: OpenStruct.new(email: keycloak_user.email, locale: 'en', pbs_id: keycloak_user.pbs_id)
        )
      end

      it do
        expect(authenticated_user).to be_persisted
        expect(authenticated_user.email).to eq(keycloak_user.email)
        expect(authenticated_user.pbs_id).to eq(keycloak_user.pbs_id)
      end

      context 'with no midata user' do
        let(:keycloak_user) { build(:user, pbs_id: nil) }

        it do
          expect(authenticated_user.pbs_id).to eq(nil)
        end
      end

      context 'with an invalid midata user' do
        let(:keycloak_user) { build(:user, pbs_id: 0) }

        it do
          expect(authenticated_user.pbs_id).to eq(nil)
        end
      end
    end
  end

  describe 'roles' do
    subject(:user) { create(:user) }

    context 'with admin role' do
      it { is_expected.not_to be_role_admin }

      it do
        user.role_admin = true
        user.save!
        expect(user).to be_role_admin
        expect(user.role_flags).to eq(0b0010)
      end
    end

    context 'with other roles' do
      it do
        user.assign_attributes(role_user: true, role_programm: true)
        user.save!
        expect(user).to be_role_user
        expect(user).to be_role_programm
        expect(user).not_to be_role_admin
        expect(user.role_flags).to eq(0b0101)
      end
    end
  end

  describe 'midata_user?' do
    subject(:user) { build(:user, pbs_id: pbs_id).midata_user? }

    let(:pbs_id) { 1 }

    it { is_expected.to be true }

    context 'when no pbs_id is given' do
      let(:pbs_id) { nil }

      it { is_expected.to be false }
    end

    context 'when no pbs_id is zero' do
      let(:pbs_id) { 0 }

      it { is_expected.to be false }
    end
  end
end
