# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :read, :create, :update, :destroy, to: :crud

    unit_permissions(user)
  end

  private

  def unit_permissions(user)
    return if user.blank?

    can :crud, Unit, al: { pbs_id: user.pbs_id }
    can :crud, Unit, lagerleiter: { pbs_id: user.pbs_id }
    # TODO: A user should only be able to see the Lagerleiter/ALs that he created. so we have to store a user_id
    # TODO: Introduce flag to avoid creation when logged in via midata
    can :create, Unit
  end
end
