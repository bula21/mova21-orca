# frozen_string_literal: true

class ParticipantUnit < ApplicationRecord
  belongs_to :participant
  belongs_to :unit
end
