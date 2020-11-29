# frozen_string_literal: true

class ActivityFilter < ApplicationFilter
  attribute :activity_type
  attribute :language
  attribute :tags, default: []
  attribute :stufe
  attribute :min_participants_count

  filter :min_participants_count do |activities|
    count = min_participants_count.to_i
    activities
      .where(Activity.arel_table[:participants_count_activity].gteq(count))
      .where(Activity.arel_table[:participants_count_transport].gteq(count))
  end

  filter :tags do |_activities|
    next nil if tags.blank?

    # activities.joins(:tags).where(tags: { id: tags })
  end

  # filter :language do |activities|
  # end
end
