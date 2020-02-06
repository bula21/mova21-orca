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

    can :read, Unit, al: { pbs_id: user.pbs_id }
    can :read, Unit, lagerleiter:  { pbs_id: user.pbs_id }
  end
end
