# frozen_string_literal: true

class ParticipantsController < ApplicationController
  load_and_authorize_resource :unit
  load_and_authorize_resource through: :unit, except: %i[new create]

  def show; end

  def new
    @participant = Participant.new
  end

  def edit; end

  def create
    @participant = Participant.new(participant_params)
    @participant.units = [@unit]
    if @participant.save
      redirect_to unit_participants_path(@unit), notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def update
    if @participant.update(participant_params)
      redirect_to unit_participants_path(@unit), notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  private

  def participant_params
    params.require(:participant).permit(:first_name, :last_name, :scout_name, :role, :gender, :birthdate, :pbs_id,
                                        :email, :phone_number)
  end
end
