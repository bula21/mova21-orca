# frozen_string_literal: true

module MidataHelper
  def group_of_camp(camp_unit_data)
    camp_unit_data.dig('linked', 'groups').find do |group|
      %w[Kantonalverband Region Abteilung].include?(group['group_type'])
    end
  end
end
