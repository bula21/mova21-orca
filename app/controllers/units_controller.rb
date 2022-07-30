# frozen_string_literal: true

class UnitsController < ApplicationController
  load_and_authorize_resource except: %i[add_document delete_document]
  skip_before_action :verify_authenticity_token, only: :add_document

  def index
    @units = @units.order(id: :asc)
    respond_to do |format|
      format.html { redirect_to unit_path(@units.take) if @units.count == 1 }
      format.json { render json: UnitBlueprint.render(@units) }
      format.csv do
        exporter = UnitExporter.new(@units)
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

  def show
    respond_to do |format|
      format.html
      format.json { render json: UnitBlueprint.render(@unit, view: :with_unit_activities) }
    end
  end

  def edit; end

  def update
    if @unit.update(unit_params)
      redirect_to units_path, notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  def accept_security_concept
    @unit = Unit.find(params[:unit_id])
    @unit.update!(accept_security_concept_at: Time.zone.now) if @unit.accept_security_concept_at.blank?
    redirect_to unit_path(@unit)
  end

  def add_document
    @unit = Unit.find(params[:unit_id])
    authorize! :manage, @unit
    @unit.documents.attach(io: File.open(params[:file]),
                           filename: (params[:filename] || params[:file].original_filename))
  end

  def delete_document
    @unit = Unit.find(params[:unit_id])
    authorize! :manage, @unit
    @unit.documents.find(params[:id]).purge

    redirect_to unit_path(@unit), notice: I18n.t('messages.deleted.success')
  end

  def emails
    @units = @units.where(id: params[:unit_ids]&.split(','))
    @emails = @units.map { |unit| unit.lagerleiter.email }
  end

  def contact
    UnitContactLog.create(user: current_user, unit: @unit)
  end

  private

  def unit_params
    permitted = %i[title abteilung kv_id stufe_id expected_participants_f expected_participants_m
                   expected_participants_leitung_f expected_participants_leitung_m visitor_day_tickets
                   starts_at ends_at al_id lagerleiter_id language week district]
    permitted += %i[pbs_id activity_booking_phase] if can?(:manage, @unit)

    params.require(:unit).permit(permitted)
  end
end
