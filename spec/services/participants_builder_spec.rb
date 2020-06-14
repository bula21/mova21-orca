# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantsBuilder do
  subject(:builder) { described_class.new }

  # `participants_json_path` is the result of `MidataService#fetch_all_participations_data`
  let(:participants_json_path) { 'spec/fixtures/extracted_participations.json' }
  let(:participants_data) { JSON.parse(File.read(Rails.root.join(participants_json_path))) }
  let(:root_camp_unit) { RootCampUnit[:pfadi] }

  describe '#from_data' do
    subject(:participants) { builder.from_data(participants_data) }

    before do
      allow(Rollbar).to receive(:warning)
    end

    it { is_expected.to all(be_a(Participant)) }

    it 'has attributes' do
      expect(participants.first).to have_attributes(
        pbs_id: 11_628,
        first_name: 'Hans',
        last_name: 'Muster',
        scout_name: 'Adler',
        # Not needed and therefore not imported
        # email: 'aa@ass.ch',
        gender: Participant.genders['male'],
        birthdate: Date.new(1984, 8, 14)
      )
    end

    it 'does not create a warning' do
      participants
      expect(Rollbar).not_to have_received(:warning)
    end

    context 'when there are no data' do
      subject(:participants_data) { [] }

      it { is_expected.to eq [] }
    end

    context 'when a user would have multiple roles' do
      let(:participants_json_path) { 'spec/fixtures/extracted_participations_with_multiple_roles.json' }

      it 'does not create a warning' do
        participants
        expect(Rollbar).not_to have_received(:warning)
      end

      context 'with Rollbar configured' do
        before do
          allow(Rollbar.configuration).to receive(:enabled).and_return(true)
        end

        it 'creates a warning' do
          participants
          expect(Rollbar).to have_received(:warning)
            .with('User with pbs_id 11629 has multiple roles in participation: '\
            '["Event::Camp::Role::Participant", "Event::Camp::Role::AssistantLeader"]')
        end
      end
    end
  end
end
