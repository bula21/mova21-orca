# frozen_string_literal: true

class ActivityFilter < ApplicationFilter
  attribute :activity_category
  attribute :languages, default: []
  attribute :tags, default: []
  attribute :text
  attribute :stufe_recommended
  attribute :unit
  attribute :min_participants_count

  filter :min_participants_count do |activities|
    count = min_participants_count.to_i
    activities
      .where(Activity.arel_table[:participants_count_activity].gteq(count))
  end

  filter :tags do |activities|
    next if tags.blank?

    activities.joins(:tags).where(tags: { id: tags }).group(:id).having("count('activities.id') = ?", tags.count)
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

    query_params = languages.each_with_object({}) { |curr, res| res[curr.to_sym] = true; }

    activities.where(Activity.bitfield_sql(query_params, query_mode: :bit_operator_or))
  end

  filter :stufe_recommended do |activities|
    next if stufe_recommended.blank?

    activities.joins(:stufe_recommended).where(activities_stufen_recommended: { stufe_id: stufe_recommended })
  end
end
