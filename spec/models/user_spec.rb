# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, :with_pbs_id) }

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
      let(:keycloak_user) { build(:user, :with_pbs_id) }
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
end
