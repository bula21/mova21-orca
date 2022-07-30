# frozen_string_literal: true

class UnitContactLog < ApplicationRecord
  belongs_to :user, class_name: 'User', optional: false, foreign_key: :user_id, inverse_of: :contact_unit_logs
end
