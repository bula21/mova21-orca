# frozen_string_literal: true

class Ability # rubocop:disable Metrics/ClassLength
  include CanCan::Ability

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def initialize(user)
    anonymous_permissions(user)
    return if user.blank?

    admin_user_permissions(user) if user.role_admin?
    checkin_checkout_user_permissions(user) if user.role_checkin_checkout?
    checkin_checkout_manager_user_permissions(user) if user.role_checkin_checkout_manager?
    tn_administration_user_permissions(user) if user.role_tn_administration?
    tn_reader_user_permissions(user) if user.role_tn_reader?
    programm_user_permissions(user) if user.role_programm?
    read_unit_user_permissions(user) if user.role_read_unit?
    allocation_user_permissions(user) if user.role_allocation?
    editor_user_permissions(user) if user.role_editor?
    midata_user_permissions(user) if user.midata_user?
    role_unit_communication_user_permissions(user) if user.role_unit_communication?
    external_user_permissions(user) unless user.midata_user?
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  private

  def anonymous_permissions(_user)
    can :read, Activity
    can :read, FixedEvent
    can :read, Checkpoint
  end

  def checkin_checkout_user_permissions(_user)
    can %i[list read redirect_to_check checkpoint_unit_autocomplete unit_autocomplete], Checkpoint
    can %i[create update read], CheckpointUnit
  end

  def checkin_checkout_manager_user_permissions(_user)
    can %i[manage], Checkpoint
    can %i[manage], CheckpointUnit
  end

  def midata_user_permissions(user)
    leader_permissions(user)
    assistant_leader_permission(user)
  end

  def leader_permissions(user)
    can :read, Leader, pbs_id: user.pbs_id

    unit_ids = Leader.where(email: user.email).map { |leader| leader.unit_ids.values }.flatten.compact
    can %i[read commit contact], Unit, id: unit_ids
    return if unit_ids.empty?

    can %i[read create], ParticipantUnit, unit_id: unit_ids
    can :read_documents, Unit, id: unit_ids
    can :accept_security_concept, Unit, id: unit_ids
    can %i[edit update destroy], ParticipantUnit, unit_id: unit_ids, participant: { pbs_id: nil }
    # can %i[read create], Participant, participant_units: { unit_id: unit_ids }
    # can %i[edit update destroy], Participant, participant_units: { unit_id: unit_ids }, pbs_id: nil
    can %i[confirm read], CheckpointUnit

    can :manage, UnitActivity, unit_id: unit_ids
    can :read, UnitActivityExecution, unit_id: unit_ids
    can %i[read update], UnitVisitorDay, unit_id: unit_ids
  end

  def assistant_leader_permission(user)
    roles = %i[assistant_leader helper]
    participant_units = ParticipantUnit.joins(:participant).where(participant: { email: user.email }, role: roles)
    unit_ids = participant_units.map(&:unit_id).flatten
    return if unit_ids.blank?

    can %i[read contact], Unit, id: unit_ids
    can :read, UnitActivity, unit: { id: unit_ids }
    can :read, ParticipantUnit, unit: { id: unit_ids }
    can :read, UnitActivityExecution, unit: { id: unit_ids }
    can :read, UnitVisitorDay, unit: { id: unit_ids }
  end

  def external_user_permissions(user)
    # TODO: A user should only be able to see the Lagerleiter/ALs that he created. so we have to store a user_id
    # TODO: Introduce flag to avoid creation when logged in via midata

    can %i[read update], Unit, al: { email: user.email }
    can %i[read update], Unit, lagerleiter: { email: user.email }
    can :manage, ParticipantUnit, unit: { lagerleiter: { email: user.email } }
    can :manage, ParticipantUnit, unit: { al: { email: user.email } }

    can :manage, UnitActivity, unit: { lagerleiter: { email: user.email } }
    can :read, UnitActivity, unit: { al: { email: user.email } }
  end

  def admin_user_permissions(_user)
    can :manage, :all
    can :export, Unit
  end

  def tn_administration_user_permissions(_user)
    can :manage, Unit
    can :manage, ParticipantUnit
    can :manage, Participant
    can :manage, Leader
    can :export, Unit
    can :manage, UnitActivity
    can :manage, UnitVisitorDay
    can :manage, Checkpoint
    can :manage, CheckpointUnit
    can :read, UnitActivityExecution
  end

  def tn_reader_user_permissions(_user)
    can :read, Unit
    can :read, ParticipantUnit
    can :read, Participant
    can :read, Leader
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
    can :manage, RoverShift
    can %i[read contact], Unit
    can :read, UnitActivityExecution
    can :read, UnitActivity
    cannot :delete, ActivityCategory, parent_id: nil
  end

  def allocation_user_permissions(user)
    programm_user_permissions(user)

    can :manage, UnitActivity
    can :manage, UnitActivityExecution
  end

  def read_unit_user_permissions(_user)
    can :read, Unit
    can :read, UnitActivity
    can :read, UnitActivityExecution
    can :read, UnitVisitorDay
  end

  def editor_user_permissions(_user)
    can :update, Activity
  end

  def role_unit_communication_user_permissions(_user)
    can %i[read emails], Unit
  end
end
