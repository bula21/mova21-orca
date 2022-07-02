# frozen_string_literal: true

class UnitActivityExecutionsController < ApplicationController
  load_and_authorize_resource :unit_activity_execution

  before_action :set_units_and_activity_executions, except: %i[index destroy]

  def index
    filter = prepare_filter
    @unit_activity_executions = filter.apply(@unit_activity_executions.ordered.with_default_includes)
    @unit_activity_executions = UnitActivityExecution.none unless filter.active?

    respond_to do |format|
      format.html
      format.csv { send_exported_data(@unit_activity_executions) }
    end
  end

  def new
    @unit_activity_execution.assign_attributes(linked_params.merge(unit_activity_execution_params))
    @unit_activity_execution.prefill_headcount
  end

  def create
    if @unit_activity_execution.save
      redirect_to unit_activity_executions_path(linked_params), notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def edit
    @unit_activity_execution.assign_attributes(unit_activity_execution_params)
  end

  def update
    @unit_activity_execution.prefill_headcount
    if @unit_activity_execution.update(unit_activity_execution_params)
      redirect_to unit_activity_executions_path(**linked_params), notice: I18n.t('messages.updated.success')
    else
      render :edit
    end
  end

  def destroy
    @unit_activity_execution.destroy
    redirect_to unit_activity_executions_path(**linked_params), notice: I18n.t('messages.deleted.success')
  end

  def import
    paramsx = params.require(:import).permit(:file, :delete_first).to_h.symbolize_keys
    @import_service = UnitActivityExecutionsImport.new(**paramsx)
    if @import_service.call
      redirect_to unit_activity_executions_path(**linked_params), notice: I18n.t('messages.import.success')
    else
      @import_errors = @import_service.errors
      render 'index'
    end
  end

  def reassign
    @filter ||= ActivityExecutionFilter.new(filter_params.reverse_merge(reassign_filter_defaults))
    @activity_executions = @filter.apply(ActivityExecution.accessible_by(current_ability)).ordered
  end

  private

  def reassign_filter_defaults
    return {} if @unit_activity_execution.blank?

    {
      activity_id: @unit_activity_execution.activity&.id,
      date: @unit_activity_execution.activity_execution&.starts_at&.to_date,
      min_available_headcount: @unit_activity_execution.unit&.actual_participants,
      language: @unit_activity_execution.unit&.language
    }
  end

  def prepare_filter
    @unit = Unit.find_by(id: params[:unit_id])
    @activity_execution = ActivityExecution.find_by(id: params[:activity_execution_id])
    @activity = Activity.find_by(id: params[:activity_id])

    UnitActivityExecutionFilter.new(unit: @unit, activity_execution: @activity_executions,
                                    activity: @activity, ids: params[:id])
  end

  def set_units_and_activity_executions
    @units = Unit.accessible_by(current_ability).order(:id)
    @activity_executions = ActivityExecution.accessible_by(current_ability).includes(:activity).order(:id)
  end

  def linked_params
    { unit_id: params[:unit_id].presence || @unit_activity_execution.unit_id,
      activity_execution_id: params[:activity_execution_id].presence }
  end

  def filter_params
    params[:activity_execution_filter]&.permit(%i[spot_id field_id starts_at_after ends_at_before activity_id
                                                  min_available_headcount max_units date language]) || {}
  end

  def unit_activity_execution_params
    params[:unit_activity_execution]&.permit(:unit_id, :activity_execution_id, :headcount,
                                             :change_remarks, :change_notification) || {}
  end

  def send_exported_data(unit_activity_executions)
    exporter = UnitActivityExecutionsExporter.new(unit_activity_executions)
    send_data exporter.export, filename: exporter.filename
  end
end
