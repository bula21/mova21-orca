# frozen_string_literal: true

class Kv < ApplicationRecord
  has_many :units, inverse_of: :kv, dependent: :destroy

  def self.midata_test_environment?
    ENV['MIDATA_BASE_URL'].include? 'pbs.puzzle.ch'
  end
end
