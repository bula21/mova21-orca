# frozen_string_literal: true

module MidataHelper
  RELEVANT_GROUP_TYPES = %w[Kantonalverband Region Abteilung].freeze

  def group_of_camp(camp_unit_data)
    camp_unit_data.dig('linked', 'groups').find do |group|
      RELEVANT_GROUP_TYPES.include?(group['group_type'])
    end
  end
end
