# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MidataService do
  let(:user_email) { 'hussein_kohlmann@hitobito.example.com' }
  let(:user_token) { 'Tu7aVJWyLYYMyCnZv2bz' }
  let(:service) { described_class.new(user_email, user_token) }

  describe '#fetch_camp' do
    use_vcr_cassette

    context 'with super_camp' do
      let(:camp_id) { '1256' }
      subject { service.fetch_camp(camp_id) }

      it do
        binding.pry
      end
    end
  end
end
