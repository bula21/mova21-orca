# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantUnitsBuilder do
  subject(:builder) { described_class.new }

  # `participants_json_path` is the result of `MidataService#fetch_all_participations_data`
  let(:participants_json_path) { 'spec/fixtures/extracted_participations.json' }
  let(:unit) { build(:unit) }
  let(:participants_data) { JSON.parse(File.read(Rails.root.join(participants_json_path))) }

  describe '#from_data' do
    subject(:unit_participants) { builder.from_data(participants_data, unit) }

    before do
      allow(Rollbar).to receive(:warning)
    end

    it { is_expected.to all(be_a(ParticipantUnit)) }

    it 'has attributes' do
      expect(unit_participants.first.participant).to have_attributes(
        pbs_id: 1866,
        first_name: 'Hans',
        last_name: 'Muster',
        scout_name: 'Adler',
        # Not needed and therefore not imported
        # email: 'aa@ass.ch',
        gender: Participant.genders['male'],
        birthdate: Date.new(1984, 8, 14)
      )
      expect(unit_participants.first.role).to eq 'participant'
    end

    it 'does not create a warning' do
      unit_participants
      expect(Rollbar).not_to have_received(:warning)
    end

    context 'when there are no data' do
      subject(:participants_data) { [] }

      it { is_expected.to eq [] }
    end

    context 'when a user would have multiple roles' do
      let(:participants_json_path) { 'spec/fixtures/extracted_participations_with_multiple_roles.json' }

      it 'does not create a warning' do
        unit_participants
        expect(Rollbar).not_to have_received(:warning)
      end

      describe 'prioritizes the right roles' do
        shared_examples 'choosing the right role' do |given_roles, expected_role|
          subject(:role) { unit_participants.first.role }

          let(:participants_data) do
            # Attention: this is a very simplified representation of the actual export with the fields needed
            [
              {
                roles: roles.map { |r| { type: r } },
                links: { person: '3186' }
              }
            ].as_json
          end

          let(:expected_role) { expected_role }

          context "when given as #{given_roles.join(',')}" do
            let(:roles) { given_roles }

            it { is_expected.to eq expected_role }
          end

          context "when given reversed as #{given_roles.reverse.join(',')}" do
            let(:roles) { given_roles.reverse }

            it { is_expected.to eq expected_role }
          end
        end

        it_behaves_like 'choosing the right role',
                        ['Event::Camp::Role::AssistantLeader', 'Event::Camp::Role::Participant'],
                        'assistant_leader'

        it_behaves_like 'choosing the right role',
                        ['Event::Camp::Role::AssistantLeader', 'Event::Camp::Role::Helper'],
                        'assistant_leader'

        it_behaves_like 'choosing the right role',
                        ['Event::Camp::Role::LeaderMountainSecurity', 'Event::Camp::Role::Participant'],
                        'leader_mountain_security'

        it_behaves_like 'choosing the right role',
                        ['Event::Camp::Role::LeaderSnowSecurity', 'Event::Camp::Role::Participant'],
                        'leader_snow_security'

        it_behaves_like 'choosing the right role',
                        ['Event::Camp::Role::LeaderWaterSecurity', 'Event::Camp::Role::Participant'],
                        'leader_water_security'

        it_behaves_like 'choosing the right role',
                        ['Event::Camp::Role::LeaderWaterSecurity', 'Event::Camp::Role::AssistantLeader'],
                        'assistant_leader'
      end

      context 'with Rollbar configured' do
        before do
          allow(Rollbar.configuration).to receive(:enabled).and_return(true)
        end

        it 'creates a warning' do
          unit_participants
          expect(Rollbar).to have_received(:warning)
            .with('User with pbs_id 11629 has multiple roles in participation: '\
                  '["Event::Camp::Role::Participant", "Event::Camp::Role::AssistantLeader"]')
        end
      end
    end

    describe 'phone_number' do
      subject(:participant) { builder.from_data(partial_participants_data, unit).first.participant.phone_number }

      let(:phone_numbers) { [] }
      let(:partial_participants_data) do
        [{ 'phone_numbers' => phone_numbers, 'roles' => [
          {
            type: 'Event::Camp::Role::Participant',
            name: 'Teilnehmer*in'
          }
        ] }]
      end

      it { is_expected.to be_nil }

      (5..9).each do |digit|
        context "when starts with 07#{digit}" do
          let(:phone_number) { "+41 7#{digit}1232345" }
          let(:phone_numbers) { [{ 'number' => phone_number, 'translated_label' => 'Handy' }] }

          it { is_expected.to eq phone_number }
        end
      end
    end
  end
end
