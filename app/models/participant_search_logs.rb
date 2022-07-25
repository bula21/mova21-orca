# frozen_string_literal: true

class ParticipantSearchLogs < ApplicationRecord
  belongs_to :searcher, class_name: 'User', optional: false
end
