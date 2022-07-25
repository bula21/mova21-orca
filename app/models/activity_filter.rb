# frozen_string_literal: true

class ActivityFilter < ApplicationFilter
  attribute :activity_category
  attribute :languages, default: -> { [] }
  attribute :tags, default: -> { [] }
  attribute :text
  attribute :stufe_recommended
  attribute :unit
  attribute :min_participants_count
  attribute :number_of_units
  attribute :number_of_units_operator, default: -> { 'eq' }

  filter :min_participants_count do |activities|
    count = min_participants_count.to_i
    activities
      .where(Activity.arel_table[:participants_count_activity].gteq(count))
  end

  filter :tags do |activities|
    next if tags.blank?

    group_statements = if stufe_recommended.blank?
                         []
                       else
                         ['activity_categories.id', 'stufen_activities.id', 'stufen.id',
                          'activity_executions.id', 'fields.id', 'spots.id',
                          'unit_activity_executions.id']
                       end
    activities.joins(:tags).where(tags: { id: tags }).group(:id, *group_statements).having(
      "count('activities.id') = ?", tags.count
    )
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

  filter :number_of_units do |activities|
    next if number_of_units.blank?

    unit_activity_execution_count = UnitActivityExecution.arel_table[:id].count

    join_activity_execution_unit(activities).having(execution_count_having_condition(unit_activity_execution_count))
  end

  private

  def execution_count_having_condition(unit_activity_execution_count)
    if number_of_units_operator.to_sym.eql?(:eq)
      unit_activity_execution_count.eq(number_of_units.to_i)
    else
      unit_activity_execution_count.gteq(number_of_units.to_i)
    end
  end

  def arel_table_activity
    Activity.arel_table
  end

  def arel_table_activity_execution
    ActivityExecution.arel_table
  end

  def arel_table_unit_activity_execution
    UnitActivityExecution.arel_table
  end

  def join_activity_execution
    activity_execution = arel_table_activity_execution
    arel_table_activity.create_on(activity_execution[:activity_id]
                                    .eq(arel_table_activity[:id]))
  end

  def join_unit_activity_execution
    unit_activity_execution = arel_table_unit_activity_execution
    arel_table_activity_execution.create_on(unit_activity_execution[:activity_execution_id]
                                              .eq(arel_table_activity_execution[:id]))
  end

  def join_activity_execution_unit(relation)
    relation.joins(arel_table_activity.create_join(arel_table_activity_execution, join_activity_execution,
                                                   Arel::Nodes::OuterJoin))
            .joins(arel_table_activity_execution.create_join(arel_table_unit_activity_execution,
                                                             join_unit_activity_execution, Arel::Nodes::InnerJoin))
            .group(arel_table_activity[:id])
  end
end
