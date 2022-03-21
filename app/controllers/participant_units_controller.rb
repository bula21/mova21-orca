# frozen_string_literal: true

class ParticipantUnitsController < ApplicationController
  load_and_authorize_resource :unit
  load_and_authorize_resource through: :unit, except: %i[new create]

  def new
    @participant_unit = @unit.participant_units.new(participant: Participant.new)
  end

  def edit; end

  def create
    @participant_unit = @unit.participant_units.new(participant_unit_params)
    if @participant_unit.save
      redirect_to unit_participant_units_path(@unit), notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def destroy
    flash = if @participant_unit.destroy
              { success: I18n.t('messages.deleted.success') }
            else
              { error: I18n.t('messages.deleted.error') }
            end
    redirect_to unit_participant_units_path(@unit), flash: flash
  end

  def update
    if @participant_unit.update(participant_unit_params)
      redirect_to unit_participant_units_path(@unit), notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  private

  def participant_unit_params
    participant_attributes = %i[first_name last_name scout_name gender birthdate pbs_id email phone_number]
    params.require(:participant_unit).permit(:role, participant_attributes: participant_attributes)
  end
end
