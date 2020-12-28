# frozen_string_literal: true

class ActivityFilter < ApplicationFilter
  attribute :activity_category
  attribute :language
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

    activities.joins(:tags).where(tags: { id: tags })
  end

  filter :activity_category do |activities|
    next nil if activity_category.blank?

    activities.where(activity_category_id: activity_category)
  end

  # filter :language do |activities|
  # end
end
