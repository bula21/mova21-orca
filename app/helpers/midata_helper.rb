# frozen_string_literal: true

module MidataHelper
  RELEVANT_GROUP_TYPES = %w[Kantonalverband Region Abteilung].freeze

  def group_of_camp(camp_unit_data)
    camp_unit_data.dig('linked', 'groups').find do |group|
      RELEVANT_GROUP_TYPES.include?(group['group_type'])
    end
  end

  def translated_midata_role(role)
    I18n.t(role.underscore.tr('/', '_'), scope: 'activerecord.attributes.participant_unit.roles')
  end

  def midata_link_to_participant(participant)
    [ENV.fetch('MIDATA_BASE_URL', nil), I18n.locale, 'people', participant.pbs_id].join('/')
  end

  def midata_link_to_unit(unit)
    [ENV.fetch('MIDATA_BASE_URL', nil), 'events', unit.pbs_id].join('/')
  end
end
