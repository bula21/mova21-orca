# frozen_string_literal: true

class Activity < ApplicationRecord
  extend Mobility

  has_many_attached :activity_documents
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :goals
  has_and_belongs_to_many :stufen
  has_and_belongs_to_many :stufe_recommended, class_name: 'Stufe', join_table: 'activities_stufen_recommended'

  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en', mixed: 'mixed' }
  enum js_type: { la: 'la', ls: 'ls', voila: 'voila' }

  validates :label, :description, :language, presence: true

  translates :label, type: :string, locale_accessors: true, fallbacks: true
  translates :description, type: :text, locale_accessors: true, fallbacks: true
end
