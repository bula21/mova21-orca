# frozen_string_literal: true

module Admin
  class CheckOutCheckpointUnitsController < ApplicationController
    load_and_authorize_resource instance_name: :checkpoint_unit, class: CheckpointUnit
    load_and_authorize_resource :check_out, class: Checkpoint, instance_name: :checkpoint

    def edit
      # false positive because of cancancan
      # rubocop:disable Style/GuardClause
      if @checkpoint_unit.blocked_by_dependency?
        redirect_to admin_check_out_path(@checkpoint),
                    notice: t('checkpoints.check_out_blocked_by_dependency',
                              checkpoint_name: @checkpoint_unit.depends_on_checkpoint.title)
      end
      # rubocop:enable Style/GuardClause
    end

    def update
      if @checkpoint_unit.checked_out_at.present?
        redirect_to admin_check_out_check_out_checkpoint_unit_path(@checkpoint, @checkpoint_unit)
      elsif @checkpoint_unit.update(check_out_checkpoint_unit_params)
        redirect_to admin_check_out_check_out_checkpoint_unit_path(@checkpoint, @checkpoint_unit),
                    notice: t('checkpoints.check_out_successful')
      else
        render :new
      end
    end

    def show
      authorize!(:create, CheckpointUnit)
    end

    def check_out_checkpoint_unit_params
      params.require(:checkpoint_unit).permit(:notes_check_out, :cost_in_chf, :checked_out_at,
                                              :checked_out_on_paper, :checked_out_by).tap do |p|
        p[:checked_out_at] = Time.zone.now
        p[:check_out_by_id] = current_user.id
      end
    end
  end
end
