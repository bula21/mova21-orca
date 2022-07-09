# frozen_string_literal: true

class CheckOutsController < ApplicationController
  load_and_authorize_resource class: CheckpointUnit, only: :confirm
  load_and_authorize_resource :unit

  def index
    @checkpoint_units = @unit.checkpoint_units
  end

  def confirm
    if @check_out.checked_out_at.present? && @check_out.confirmed_checked_out_at.blank?
      @check_out.update!(confirmed_checked_out_at: Time.zone.now, confirmed_check_out_by_id: current_user.id)
    end

    redirect_to unit_check_outs_path(@unit)
  end
end
