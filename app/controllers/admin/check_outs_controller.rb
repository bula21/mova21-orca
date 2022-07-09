# frozen_string_literal: true

module Admin
  class CheckOutsController < ApplicationController
    load_and_authorize_resource instance_name: :checkpoint, class: Checkpoint, except: [:index]
    load_and_authorize_resource :checkpoint_unit, only: [:redirect_to_check]

    def index; end

    def show; end

    def checkpoint_unit_autocomplete
      checkpoint_units = CheckpointUnit.joins(:unit).where(checkpoint_id: @checkpoint.id)
      checkpoint_units = checkpoints_filtered_by_query(checkpoint_units)
      render layout: false, partial: 'checkpoint_unit_autocomplete', locals: { checkpoint_units: checkpoint_units }
    end

    # rubocop:disable Metrics/MethodLength
    def redirect_to_check
      checkpoint_unit_id = params[:checkpoint_unit_id]
      checkpoint_unit = CheckpointUnit.where(id: checkpoint_unit_id).first
      if checkpoint_unit.present?
        if checkpoint_unit.checked_out_at.blank?
          redirect_to edit_admin_check_out_check_out_checkpoint_unit_path(@checkpoint, checkpoint_unit)
        else
          redirect_to admin_check_out_check_out_checkpoint_unit_path(@checkpoint, checkpoint_unit)
        end
      else
        redirect_to admin_check_out_path(@checkpoint)
      end
    end
    # rubocop:enable Metrics/MethodLength

    private

    def checkpoints_filtered_by_query(checkpoint_units)
      if params[:q].to_i.to_s.eql?(params[:q])
        checkpoint_units.where(unit: { id: params[:q] })
      else
        checkpoint_units.where('units.title LIKE ?', "%#{params[:q]}%")
      end
    end
  end
end
