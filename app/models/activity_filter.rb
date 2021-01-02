# frozen_string_literal: true

class ActivityFilter < ApplicationFilter
  attribute :activity_category
  attribute :languages, default: []
  attribute :tags, default: []
  attribute :stufe
  attribute :min_participants_count

  filter :min_participants_count do |activities|
    count = min_participants_count.to_i
    activities
      .where(Activity.arel_table[:participants_count_activity].gteq(count))
  end

  filter :tags do |activities|
    next nil if tags.blank?

    activities.joins(:tags).where(tags: { id: tags }).group(:id).having("count('activities.id') = ?", tags.count)
  end

  filter :activity_category do |activities|
    next nil if activity_category.blank?

    activities.where(activity_category_id: activity_category)
  end

  filter :languages do |activities|
    next nil if languages.blank?

    query_params = languages.each_with_object({}) { |curr, res| res[curr.to_sym] = true; }

    activities.where(Activity.bitfield_sql(query_params, query_mode: :bit_operator_or))
  end

  filter :stufe do |activities|
    next nil if stufe.blank?

    join_tables = activities.joins(:stufen, :stufe_recommended)
    join_tables.where(activities_stufen_recommended: { stufe_id: stufe })
               .or(join_tables.where(activities_stufen: { stufe_id: stufe }))
  end
end
