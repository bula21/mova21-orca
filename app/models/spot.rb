# frozen_string_literal: true

class Spot < ApplicationRecord
  extend Mobility

  has_many :fields, lambda {
                      order(Arel.sql("LOWER(fields.name->>'de'), fields.name->>'de'"))
                    }, inverse_of: :spot, dependent: :destroy
  translates :name, locale_accessors: true, fallbacks: true

  def to_s
    name
  end
end
