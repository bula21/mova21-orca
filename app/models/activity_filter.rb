# frozen_string_literal: true

class ActivityFilter < ApplicationFilter
  attribute :activity_category
  attribute :languages, default: -> { [] }
  attribute :tags, default: -> { [] }
  attribute :text
  attribute :stufe_recommended
  attribute :unit
  attribute :min_participants_count
  attribute :only_booked

  filter :min_participants_count do |activities|
    next if min_participants_count.blank?

    activities.where(Activity.arel_table[:participants_count_activity].gteq(min_participants_count.to_i))
  end

  filter :tags do |activities|
    tags = Array.wrap(tags.compact_blank)
    next if tags.blank?

    activities_with_all_tags = Activity.joins(:tags).where(activities_tags: { tag_id: tags })
                                       .group(Activity.arel_table[:id])
                                       .having(Tag.arel_table[:id].count.eq(tags.count))
    activities.where(id: activities_with_all_tags.pluck(:id))
  end

  filter :text do |activities|
    next if text.blank? || text.length < 3

    match_text = text
    activities.merge(Activity.i18n { label.matches("%#{match_text}%") })
  end

  filter :activity_category do |activities|
    next if activity_category.blank?

    activities.where(activity_category_id: activity_category)
  end

  filter :languages do |activities|
    next if languages.blank?

    query_params = languages.each_with_object({}) { |curr, res| res["language_#{curr}".to_sym] = true; }
    activities.where(Activity.bitfield_sql(query_params, query_mode: :bit_operator_or))
  end

  filter :stufe_recommended do |activities|
    next if stufe_recommended.blank?

    activities.joins(:stufe_recommended).where(activities_stufen_recommended: { stufe_id: stufe_recommended })
  end

  filter :only_booked do |activities|
    next if only_booked.blank? || only_booked.to_s.to_i.zero?

    activities_with_units = Activity.joins(activity_executions: :unit_activity_executions)
                                    .group(Activity.arel_table[:id])
                                    .having(UnitActivityExecution.arel_table[:id].count.gt(0))
    activities.where(id: activities_with_units.pluck(:id))
  end
end
