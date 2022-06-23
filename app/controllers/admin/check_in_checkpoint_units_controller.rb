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

    def show
      authorize!(:create, CheckpointUnit)
    end

    def check_in_checkpoint_unit_params
      params.require(:checkpoint_unit).permit(:checkpoint_id, :unit_id, :notes_check_in, :checked_in_on_paper,
                                              :check_in_by_id).tap do |p|
        p[:check_in_by_id] = current_user.id
      end
    end

    private

    def ensure_not_existent
      @checkpoint_unit
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
