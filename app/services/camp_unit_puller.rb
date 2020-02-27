# frozen_string_literal: true

class CampUnitPuller
  def initialize(root_camp_unit)
    @root_camp_unit = root_camp_unit
    @camp_unit_builder = CampUnitBuilder.new(root_camp_unit)
    @midata_service = MidataService.new
  end

  def pull(pbs_id)
    camp_unit_data = @midata_service.fetch_camp_unit_data(pbs_id)
    @camp_unit_builder.from_data(camp_unit_data, id: pbs_id)
  end

  def pull_camp_unit_hierarchy
    camp_unit_data_hierarchy = @midata_service.fetch_camp_unit_data_hierarchy(@root_camp_unit.root_id)
    camp_unit_data_hierarchy.map do |camp_unit_data|
      @camp_unit_builder.from_data(camp_unit_data)
    end
  end

  def pull_new_camp_units_from_camp_unit_hierarchy
    root_data = @midata_service.fetch_camp_unit_data(@root_camp_unit.root_id)
    children_ids = root_data.dig('events', 0, 'links', 'sub_camps')
    existing_ids = Unit.all.pluck(:pbs_id)

    (children_ids - existing_ids).map { |new_camp_unit_id| pull(new_camp_unit_id) }
  end
end
