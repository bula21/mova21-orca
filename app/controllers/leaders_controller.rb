# frozen_string_literal: true

class LeadersController < ApplicationController
  before_action :set_leader, only: %i[edit update show]
  def index; end

  def new
    @leader = Leader.new
  end

  def create
    @leader = Leader.new(leader_params)

    if @leader.save
      redirect_to leaders_path, notice: I18n.t('leaders.messages.created.success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @leader.update(leader_params)
      redirect_to leaders_path, notice: I18n.t('leaders.messages.updated.success')
    else
      render :edit
    end
  end

  private

  def set_leader
    @leader = Leader.find params[:id]
  end

  def leader_params
    params.require(:leader).permit(:last_name, :first_name, :scout_name, :birthdate, :gender, :email, :phone_number,
                                   :language, :address, :zip_code, :town, :country, :pbs_id)
  end
end
