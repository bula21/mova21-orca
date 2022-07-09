# frozen_string_literal: true

class CheckInsController < ApplicationController
  load_and_authorize_resource class: CheckpointUnit, only: :confirm
  load_and_authorize_resource :unit, except: [:unit_autocomplete]

  def index
    @checkpoint_units = @unit.checkpoint_units
  end

  def confirm
    if @check_in.confirmed_checked_in_at.blank?
      @check_in.update!(confirmed_checked_in_at: Time.zone.now, confirmed_check_in_by_id: current_user.id)
    end

    redirect_to unit_check_ins_path(@unit)
  end
end
