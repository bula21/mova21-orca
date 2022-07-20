# frozen_string_literal: true

module Admin
  class CheckInCheckpointUnitsController < ApplicationController
    load_and_authorize_resource instance_name: :checkpoint_unit, class: CheckpointUnit
    load_and_authorize_resource :check_in, class: Checkpoint, instance_name: :checkpoint

    def new
      @checkpoint_unit.checkpoint = @checkpoint
      @checkpoint_unit.unit_id = params[:unit_id]
    end

    def create
      if @checkpoint_unit.save
        create_depending_checkpoint_units

        redirect_to admin_check_in_check_in_checkpoint_unit_path(@checkpoint, @checkpoint_unit),
                    notice: t('checkpoints.check_in_successfully_created')
      else
        render :new
      end
    end

    def edit; end

    def update
      if @checkpoint_unit.update(update_check_in_checkpoint_unit_params)
        update_depending_checkpoint_units
        redirect_to admin_check_in_check_in_checkpoint_unit_path(@checkpoint, @checkpoint_unit),
                    notice: t('checkpoints.check_in_successfully_created')
      else
        render :edit
      end
    end

    def show
      if @checkpoint_unit.checked_in_at.blank?
        redirect_to edit_admin_check_in_check_in_checkpoint_unit_path(@checkpoint, @checkpoint_unit)
      end
      authorize!(:create, CheckpointUnit)
    end

    def check_in_checkpoint_unit_params
      params.require(:checkpoint_unit).permit(:checkpoint_id, :unit_id, :notes_check_in, :checked_in_on_paper,
                                              :check_in_by_id).tap do |p|
        p[:check_in_by_id] = current_user.id
      end
    end

    private

    def update_check_in_checkpoint_unit_params
      check_in_checkpoint_unit_params.tap do |p|
        if @checkpoint_unit.checked_in_at.blank?
          p[:checked_in_at] = Time.zone.now
          p[:check_in_by_id] = current_user.id
        end
        p[:confirmed_checked_in_at] = nil
        p[:confirmed_check_in_by_id] = nil
        p[:confirmed_checked_out_at] = nil
        p[:confirmed_check_out_by_id] = nil
      end
    end

    def update_depending_checkpoint_units
      @checkpoint_unit.unit.checkpoint_units.where(checkpoint: @checkpoint_unit.dependant_checkpoints)
                      .each do |dependent_checkpoint_unit|
        dependent_checkpoint_unit.update!(update_check_in_checkpoint_unit_params.to_h.without(:checkpoint_id))
      end
    end

    def create_depending_checkpoint_units
      @checkpoint_unit.dependant_checkpoints.each do |dc|
        @checkpoint_unit.dup.tap do |duplicate|
          duplicate.checkpoint = dc
        end.save!
      end
    end
  end
end
