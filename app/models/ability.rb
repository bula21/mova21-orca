# frozen_string_literal: true

class Ability # rubocop:disable Metrics/ClassLength
  include CanCan::Ability

  def self.role(role_name, &block)
    roles[role_name.to_sym] = block
  end

  def self.roles
    @roles ||= {}
  end

  def initialize(user)
    roles = [:anonymous, user&.roles, (user&.midata_user? ? :midata : :external)].flatten.compact
    roles.each { |role_name| permit(role_name, user) }
  end

  private

  def permit(role_name, user)
    Rails.logger.debug { "  ** Giving #{role_name} permissions to #{user}" }
    instance_exec(user, &self.class.roles.fetch(role_name.to_sym))
  end

  role :user do |user|
    can :read, user
  end

  role :anonymous do
    can :read, Activity
    can :read, FixedEvent
    can :read, Checkpoint
  end

  role :checkin_checkout do
    can %i[list read redirect_to_check checkpoint_unit_autocomplete unit_autocomplete], Checkpoint
    can %i[create update read], CheckpointUnit
  end

  role :checkin_checkout_manager do
    can %i[manage], Checkpoint
    can %i[manage], CheckpointUnit
  end

  role :midata do |user|
    permit(:leader, user)
    permit(:assistant_leader, user)
  end

  role :leader do |user|
    next if user.blank?

    can :read, Leader, pbs_id: user.pbs_id

    unit_ids = Leader.where(email: user.email).map { |leader| leader.unit_ids.values }.flatten.compact
    can %i[read commit contact], Unit, id: unit_ids
    next if unit_ids.empty?

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

  role :assistant_leader do |user|
    next if user.blank?

    roles = %i[assistant_leader helper]
    participant_units = ParticipantUnit.joins(:participant).where(participant: { email: user.email }, role: roles)
    unit_ids = participant_units.map(&:unit_id).flatten
    next if unit_ids.blank?

    can %i[read contact], Unit, id: unit_ids
    can :read, UnitActivity, unit: { id: unit_ids }
    can :read, ParticipantUnit, unit: { id: unit_ids }
    can :read, UnitActivityExecution, unit: { id: unit_ids }
    can :read, UnitVisitorDay, unit: { id: unit_ids }
  end

  role :external do |user|
    # TODO: A user should only be able to see the Lagerleiter/ALs that he created. so we have to store a user_id
    # TODO: Introduce flag to avoid creation when logged in via midata
    next if user.blank?

    email = user.email

    can %i[read update], Unit, al: { email: email }
    can %i[read update], Unit, lagerleiter: { email: email }
    can :manage, ParticipantUnit, unit: { lagerleiter: { email: email } }
    can :manage, ParticipantUnit, unit: { al: { email: email } }

    can :manage, UnitActivity, unit: { lagerleiter: { email: email } }
    can :read, UnitActivity, unit: { al: { email: email } }
  end

  role :admin do
    can :manage, :all
    can :export, Unit
  end

  role :tn_administration do
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

  role :tn_reader do
    can %i[read contact], Unit
    can :read, ParticipantUnit
    can :read, Participant
    can :read, Leader
  end

  role :programm do
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

  role :allocation do |user|
    permit(:programm, user)

    can :manage, UnitActivity
    can :manage, UnitActivityExecution
  end

  role :read_unit do
    can :read, Unit
    can :read, UnitActivity
    can :read, UnitActivityExecution
    can :read, UnitVisitorDay
  end

  role :editor do
    can :update, Activity
  end

  role :unit_communication do
    can %i[read emails], Unit
  end

  role :participant_searcher do
    can :read, Unit
    can :search, Participant
  end

  role :read_allocation do
    can :read, Activity
    can :read, UnitActivity
    can :read, ActivityExecution
    can :read, UnitActivityExecution
  end

  role :read_unit_contact do
    can %i[read contact], Unit
  end
end
