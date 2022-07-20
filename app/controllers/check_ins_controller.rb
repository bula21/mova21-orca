# frozen_string_literal: true

class CheckInsController < ApplicationController
  load_and_authorize_resource class: CheckpointUnit, only: :confirm
  load_and_authorize_resource :unit, except: %i[unit_autocomplete staff]

  def index
    @checkpoint_units = @unit.checkpoint_units
  end

  def confirm
    if @check_in.confirmed_checked_in_at.blank?
      @check_in.update!(confirmed_checked_in_at: Time.zone.now, confirmed_check_in_by_id: current_user.id)
      confirm_depending_checkpoint_units!
    end

    redirect_to unit_check_ins_path(@unit)
  end

  def staff
    current_user.update(role_checkin_checkout: true) if params[:token] == ENV.fetch('STAFF_TOKEN')
    redirect_to admin_check_ins_path
  end

  def confirm_depending_checkpoint_units!
    @check_in.unit.checkpoint_units.where(checkpoint: @check_in.dependant_checkpoints)
             .each do |dependent_checkpoint_unit|
      dependent_checkpoint_unit.update!(confirmed_checked_in_at: @check_in.confirmed_checked_in_at,
                                        confirmed_check_in_by_id: @check_in.confirmed_check_in_by_id)
    end
  end
end
