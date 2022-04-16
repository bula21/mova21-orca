# frozen_string_literal: true

class ParticipantUnit < ApplicationRecord
  # The order of the keys defines the importance of the roles in the import. It would prioritize the first key over the
  # second
  MIDATA_EVENT_CAMP_ROLES = {
    assistant_leader: 'Event::Camp::Role::AssistantLeader',
    helper: 'Event::Camp::Role::Helper',
    leader_mountain_security: 'Event::Camp::Role::LeaderMountainSecurity',
    leader_snow_security: 'Event::Camp::Role::LeaderSnowSecurity',
    leader_water_security: 'Event::Camp::Role::LeaderWaterSecurity',
    participant: 'Event::Camp::Role::Participant'
  }.freeze

  belongs_to :participant, inverse_of: :participant_units
  belongs_to :unit, inverse_of: :participant_units

  accepts_nested_attributes_for :participant, reject_if: :all_blank
  validates_associated :participant

  scope :with_role, ->(role) { where(role: role) }

  enum role: MIDATA_EVENT_CAMP_ROLES
end
