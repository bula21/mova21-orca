# frozen_string_literal: true

class FixedEvent < ApplicationRecord
  extend Mobility
  validates_with StartBeforeEndValidator
  validates :starts_at, :ends_at, presence: true
  validates :stufe_ids, presence: true

  has_and_belongs_to_many :stufen

  has_many_attached :language_documents_de
  has_many_attached :language_documents_fr
  has_many_attached :language_documents_it

  translates :title, locale_accessors: true, fallbacks: true

  ATTACHMENTS = %i[language_documents_de language_documents_fr language_documents_it].freeze
end
