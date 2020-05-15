# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can :manage, Tag # TODO: define rights for tags

    admin_user_permissions(user) if user.role_admin?
    programm_user_permissions(user) if user.role_programm?

    if user.pbs_id
      midata_user_permissions(user)
    else
      external_user_permissions(user)
    end
  end

  private

  def midata_user_permissions(user)
    can %i[read], Unit, al: { pbs_id: user.pbs_id }
    can %i[read], Unit, lagerleiter: { pbs_id: user.pbs_id }
    # can %i[read update], Unit, coach: { pbs_id: user.pbs_id }
    can :read, Leader, pbs_id: user.pbs_id

    can :read, Participant, unit: { al: { pbs_id: user.pbs_id } }
    can :read, Participant, unit: { lagerleiter: { pbs_id: user.pbs_id } }

    can :read, Activity
  end

  def external_user_permissions(user)
    # TODO: A user should only be able to see the Lagerleiter/ALs that he created. so we have to store a user_id
    # TODO: Introduce flag to avoid creation when logged in via midata

    can :create, Unit unless user.pbs_id.present?
    can %i[read update], Unit, al: { pbs_id: user.pbs_id }
    can %i[read update], Unit, lagerleiter: { pbs_id: user.pbs_id }

    can :manage, Participant, unit: { lagerleiter: { pbs_id: user.pbs_id } }
    can :manage, Participant, unit: { al: { pbs_id: user.pbs_id } }

    can :read, Activity
  end

  def admin_user_permissions(_user)
    can :manage, :all
    can :export, Unit
  end

  def programm_user_permissions(_user)
    can :manage, Activity
  end
end
