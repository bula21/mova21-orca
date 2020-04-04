# frozen_string_literal: true

class ParticipantsController < ApplicationController
  load_and_authorize_resource :unit
  load_and_authorize_resource through: :unit

  def index; end

  def show; end

  def new; end

  def edit; end

  def create
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
    params.require(:participant).permit(:first_name, :last_name, :scout_name, :gender, :birthdate, :pbs_id)
  end
end
