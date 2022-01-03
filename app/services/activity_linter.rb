# frozen_string_literal: true

class ActivityLinter
  CHECKS = {
    title_translated: ->(activity) { activity.label_in_database.values.count(&:present?) > 3 },
    description_translated: ->(activity) { activity.description_in_database.values.count(&:present?) > 3 },
    participant_count_min: ->(activity) { activity.participants_count_activity&.>=(12) },
    valid: ->(activity) { activity.valid? },
    languages_min: ->(activity) { activity.languages.values.count(&:itself) >= 1 },
    stufen_min: ->(activity) { (activity.stufe_ids & activity.stufe_recommended_ids).count >= 1 }
  }.freeze

  def lint(activities = Activity.all)
    failed_checks = CHECKS.transform_values { [] }
    activities.find_each do |activity|
      CHECKS.each { |check, check_proc| check_proc.call(activity) || (failed_checks[check] << activity.id) }
    end
    failed_checks
  end
end
