# frozen_string_literal: true

class UnitsController < ApplicationController
  before_action :set_unit, only: %i[edit update show]
  def index; end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to units_path, notice: I18n.t('units.messages.created.success')
    else
      render :new
    end
  end

  def show
    survey_id = 187799
    lang = 'de-informal'
    @limesurvey_url = "#{LimesurveyService::BASEURL}/#{survey_id}?lang=#{lang}&token=#{@unit.limesurvey_token}"
  end

  def edit; end

  def update
    if @unit.update(unit_params)
      redirect_to units_path, notice: I18n.t('units.messages.updated.success')
    else
      render :edit
    end
  end

  private

  def set_unit
    @unit = Unit.find params[:id]
  end

  def unit_params
    params.require(:unit).permit(:title, :abteilung, :kv, :stufe, :expected_participants_f, :expected_participants_m,
                                 :expected_participants_leitung_f, :expected_participants_leitung_m,
                                 :starts_at, :ends_at, :al_id, :lagerleiter_id)
  end
end
