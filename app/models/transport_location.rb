# frozen_string_literal: true

# == Schema Information
#
# Table name: transport_locations
#
#  id               :bigint           not null, primary key
#  max_participants :integer
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class TransportLocation < ApplicationRecord
  has_and_belongs_to_many :activities

  validates :name, :max_participants, presence: true

  def to_s
    "#{name} (max. #{max_participants})"
  end
end
