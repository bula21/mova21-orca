# frozen_string_literal: true

class Activity < ApplicationRecord
  extend Mobility

  has_many_attached :activity_documents
  has_one_attached :picture
  has_and_belongs_to_many :tags, optional: true
  belongs_to :transport_location, optional: true
  has_and_belongs_to_many :goals
  has_and_belongs_to_many :stufen
  has_and_belongs_to_many :stufe_recommended, class_name: 'Stufe', join_table: 'activities_stufen_recommended'

  enum language: { de: 'de', fr: 'fr', it: 'it', en: 'en', mixed: 'mixed' }
  enum block_type: { la: 'la', ls: 'ls' }
  enum simo: { berg: 'berg', wasser: 'wasser' }
  enum activity_type: { excursion: 'excursion', activity: 'activity', village_global: 'village_global' }

  validates :label, :description, :language, :block_type, :participants_count_activity,
            :participants_count_transport, :stufen, :stufe_recommended, :activity_type, presence: true

  translates :label, type: :string, locale_accessors: true, fallbacks: true
  translates :description, type: :text, locale_accessors: true, fallbacks: true
end
