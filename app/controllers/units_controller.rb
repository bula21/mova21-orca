# frozen_string_literal: true

class UnitsController < ApplicationController
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.csv do
        exporter = UnitExporter.new(Unit.accessible_by(current_ability))
        send_data exporter.export, filename: exporter.filename
      end
    end
  end

  def new
    @unit = Unit.new
  end

  def create
    @unit = Unit.new(unit_params)

    if @unit.save
      redirect_to units_path, notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @unit.update(unit_params)
      redirect_to units_path, notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  def add_document
    @unit = Unit.find(params[:unit_id])
    authorize! :manage, @unit
    @unit.documents.attach(params[:file])
  end

  private

  def unit_params
    params.require(:unit).permit(:title, :abteilung, :kv_id, :stufe, :expected_participants_f, :expected_participants_m,
                                 :expected_participants_leitung_f, :expected_participants_leitung_m,
                                 :starts_at, :ends_at, :al_id, :lagerleiter_id, :language, :week, :district)
  end
end
