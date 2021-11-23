# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def initialize(user)
    anonymous_permissions(user)
    return if user.blank?

    admin_user_permissions(user) if user.role_admin?
    tn_administration_user_permissions(user) if user.role_tn_administration?
    programm_user_permissions(user) if user.role_programm?
    allocation_user_permissions(user) if user.role_allocation?
    editor_user_permissions(user) if user.role_editor?
    midata_user_permissions(user) if user.midata_user?
    external_user_permissions(user) unless user.midata_user?
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  private

  def anonymous_permissions(_user)
    can :read, Activity
  end

  # rubocop:disable Metrics/MethodLength
  def midata_user_permissions(user)
    can %i[read commit], Unit, al: { email: user.email }
    can %i[read commit], Unit, lagerleiter: { email: user.email }
    # can %i[read update], Unit, coach: { pbs_id: user.pbs_id }
    can :read, Leader, pbs_id: user.pbs_id

    can %i[read create], Participant, units: { al: { email: user.email } }
    can %i[read create], Participant, units: { lagerleiter: { email: user.email } }
    can %i[edit update destroy], Participant, pbs_id: nil, units: { al: { email: user.email } }
    can %i[edit update destroy], Participant, pbs_id: nil, units: { lagerleiter: { email: user.email } }
    can :manage, UnitActivity, unit: { lagerleiter: { email: user.email } }
    can :manage, UnitActivity, unit: { al: { email: user.email } }
    can :read, UnitActivityExecution, unit: { lagerleiter: { email: user.email } }
    can :read, UnitActivityExecution, unit: { al: { email: user.email } }

    assistant_leader_permission(user)
  end
  # rubocop:enable Metrics/MethodLength

  def assistant_leader_permission(user)
    participants = Participant.assistant_leader.where(email: user.email)
    unit_ids = participants.map(&:unit_ids).flatten
    return if unit_ids.empty?

    can :read, Unit, id: unit_ids
    can :read, UnitActivity, unit: { id: unit_ids }
    can :read, Participant, units: { id: unit_ids }
    can :read, UnitActivityExecution, unit: { id: unit_ids }
  rescue StandardError => e
    Rollbar.warning e if Rollbar.configuration.enabled
  end

  def external_user_permissions(user)
    # TODO: A user should only be able to see the Lagerleiter/ALs that he created. so we have to store a user_id
    # TODO: Introduce flag to avoid creation when logged in via midata

    can %i[read update], Unit, al: { email: user.email }
    can %i[read update], Unit, lagerleiter: { email: user.email }
    can :manage, Participant, units: { lagerleiter: { email: user.email } }
    can :manage, Participant, units: { al: { email: user.email } }

    can :manage, UnitActivity, unit: { lagerleiter: { email: user.email } }
    can :read, UnitActivity, unit: { al: { email: user.email } }
  end

  def admin_user_permissions(_user)
    can :manage, :all
    can :export, Unit
  end

  def tn_administration_user_permissions(_user)
    can :manage, Unit
    can :manage, Participant
    can :manage, Leader
    can :export, Unit
    can :manage, UnitActivity
  end

  def programm_user_permissions(_user)
    can :manage, Activity
    can :manage, ActivityExecution
    can :manage, Tag
    can :manage, Stufe
    can :manage, TransportLocation
    can :manage, FixedEvent
    can :manage, ActivityCategory
    can :manage, Spot
    can :manage, Field
    cannot :delete, ActivityCategory, parent_id: nil
  end

  def allocation_user_permissions(user)
    programm_user_permissions(user)

    can :manage, UnitActivity
    can :manage, Unit
    can :manage, UnitActivityExecution
  end

  def editor_user_permissions(_user)
    can :edit, Activity
  end
end
