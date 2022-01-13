# frozen_string_literal: true

class ParticipantUnit < ApplicationRecord
  MIDATA_EVENT_CAMP_ROLES = {
    participant: 'Event::Camp::Role::Participant',
    assistant_leader: 'Event::Camp::Role::AssistantLeader',
    helper: 'Event::Camp::Role::Helper',
    leader_mountain_security: 'Event::Camp::Role::LeaderMountainSecurity',
    leader_snow_security: 'Event::Camp::Role::LeaderSnowSecurity',
    leader_water_security: 'Event::Camp::Role::LeaderWaterSecurity'
  }.freeze

  belongs_to :participant, inverse_of: :participant_units
  belongs_to :unit, inverse_of: :participant_units

  scope :with_role, ->(role) { where(role: role) }

  enum role: MIDATA_EVENT_CAMP_ROLES
end
