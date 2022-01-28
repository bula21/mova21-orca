# frozen_string_literal: true

module DeleteActivityExecutionsHelper
  def activity_executions_collection(activity)
    (Orca::CAMP_START..Orca::CAMP_END).map do |day|
      amount = I18n.t('delete_activity_executions.index.activity_executions_count',
                      count: amount_of_executions_on_day(day, activity))
      ["#{formatted_date(day)} (#{amount})", day]
    end
  end

  private

  def formatted_date(day)
    I18n.l(day, format: '%a %d.%m.%Y KW%W')
  end

  def amount_of_executions_on_day(day, activity)
    activity.activity_executions.where('starts_at::date = ?', day).count
  end
end
