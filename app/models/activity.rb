# frozen_string_literal: true

class Activity < ApplicationRecord
  extend Mobility

  has_many_attached :activity_documents

  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en', mixed: 'mixed' }
  enum js_type: { la: 'la', ls: 'ls' }

  validates :label, :description, :language, presence: true

  translates :label, type: :string, locale_accessors: true, fallbacks: true
  translates :description, type: :text, locale_accessors: true, fallbacks: true
end
