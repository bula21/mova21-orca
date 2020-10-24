# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    admin_user_permissions(user) if user.role_admin?
    tn_administration_user_permissions(user) if user.role_tn_administration?
    programm_user_permissions(user) if user.role_programm?

    if user.midata_user?
      midata_user_permissions(user)
    else
      external_user_permissions(user)
    end
  end

  private

  def midata_user_permissions(user)
    can %i[read], Unit, al: { email: user.email }
    can %i[read], Unit, lagerleiter: { email: user.email }
    # can %i[read update], Unit, coach: { pbs_id: user.pbs_id }
    can :read, Leader, pbs_id: user.pbs_id

    can :read, Participant, unit: { al: { email: user.email } }
    can :read, Participant, unit: { lagerleiter: { email: user.email } }

    can :read, Activity
  end

  def external_user_permissions(user)
    # TODO: A user should only be able to see the Lagerleiter/ALs that he created. so we have to store a user_id
    # TODO: Introduce flag to avoid creation when logged in via midata

    can %i[read update], Unit, al: { email: user.email }
    can %i[read update], Unit, lagerleiter: { email: user.email }
    can :manage, Participant, unit: { lagerleiter: { email: user.email } }
    can :manage, Participant, unit: { al: { email: user.email } }

    can :read, Activity
  end

  def admin_user_permissions(_user)
    can :manage, :all
    can :export, Unit
  end

  def tn_administration_user_permissions(_user)
    can :manage, Unit
    can :manage, Participant
    can :manage, Leader
  end

  def programm_user_permissions(_user)
    can :manage, Activity
    can :manage, Tag
    can :manage, TransportLocation
    can :manage, ActivityCategory
  end
end
