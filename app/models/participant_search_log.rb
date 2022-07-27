# frozen_string_literal: true

class ParticipantSearchLog < ApplicationRecord
  belongs_to :searcher, class_name: 'User', optional: false, foreign_key: :user_id, inverse_of: :participant_search_logs
end
