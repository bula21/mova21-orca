# frozen_string_literal: true

module Admin
  class CheckInsController < ApplicationController
    load_and_authorize_resource instance_name: :checkpoint, class: Checkpoint, only: %i[show redirect_to_check]

    def index
      authorize!(:list, Checkpoint)
    end

    def show
      authorize!(:create, CheckpointUnit)
    end

    def unit_autocomplete
      units = if params[:q].to_i.to_s.eql?(params[:q])
                Unit.where(id: params[:q])
              else
                Unit.where('title LIKE ?',
                           "%#{params[:q]}%")
              end
      render layout: false, partial: 'unit_autocomplete', locals: { units: units }
    end

    # rubocop:disable Metrics/MethodLength
    def redirect_to_check
      unit_id = params[:unit_id]
      if unit_id.present?
        checkpoint_unit = CheckpointUnit.where(unit_id: unit_id, checkpoint: @checkpoint).first

        if checkpoint_unit.present?
          redirect_to admin_check_in_check_in_checkpoint_unit_path(@checkpoint, checkpoint_unit)
        else
          redirect_to new_admin_check_in_check_in_checkpoint_unit_path(@checkpoint, unit_id: unit_id)
        end
      else
        redirect_to admin_check_in_path(@checkpoint)
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
