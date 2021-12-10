# frozen_string_literal: true

class UnitActivityExecutionsController < ApplicationController
  load_and_authorize_resource :unit_activity_execution
  before_action :set_units_and_activity_executions, except: %i[index destroy]

  def index
    @unit = Unit.find_by(id: params[:unit_id])
    execution = ActivityExecution.find_by(id: params[:activity_execution_id])
    @activity_execution = execution

    @unit_activity_executions = @unit_activity_executions.where(unit: @unit) if @unit
    @unit_activity_executions = @unit_activity_executions.where(activity_execution: execution) if execution
  end

  def new
    @unit_activity_execution.assign_attributes(**linked_params)
    @unit_activity_execution.prefill_headcount
  end

  def create
    if @unit_activity_execution.save
      redirect_to unit_activity_executions_path(**linked_params), notice: I18n.t('messages.created.success')
    else
      render :new
    end
  end

  def edit; end

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
    @import_service = UnitActivityExecutionsImport.new(params.require(:import).permit(:file)[:file])
    if @import_service.call
      redirect_to unit_activity_executions_path(**linked_params), notice: I18n.t('messages.import.success')
    else
      @import_errors = @import_service.errors
      render 'index'
    end
  end

  private

  def set_units_and_activity_executions
    @units = Unit.accessible_by(current_ability).order(:id)
    @activity_executions = ActivityExecution.accessible_by(current_ability).includes(:activity).order(:id)
  end

  def linked_params
    { unit_id: params[:unit_id], activity_execution_id: params[:activity_execution_id] }
  end

  def unit_activity_execution_params
    params[:unit_activity_execution].permit(:unit_id, :activity_execution_id, :headcount)
  end
end
