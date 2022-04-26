# frozen_string_literal: true

class ActivityExecutionsController < ApplicationController
  load_and_authorize_resource :activity
  load_and_authorize_resource through: :activity, shallow: true
  before_action :set_spots, only: :index

  def index
    @activity_executions = filter.apply(@activity_executions).ordered
    respond_to do |format|
      format.json { render json: ActivityExecutionBlueprint.render(@activity_executions, view: :with_fields) }
      format.html
    end
  end

  def create
    @activity_execution = @activity.activity_executions.create(activity_execution_params)
    if @activity_execution.persisted?
      render status: :ok, json: { success: true, data: ActivityExecutionBlueprint.render_as_hash(@activity_execution) }
    else
      render status: :bad_request, json: { success: false, errors: @activity_execution.errors.full_messages }
    end
  end

  def update
    if @activity_execution.update(activity_execution_params)
      render status: :ok, json: { success: true, data: ActivityExecutionBlueprint.render_as_hash(@activity_execution) }
    else
      render status: :bad_request, json: { success: false, errors: @activity_execution.errors.full_messages }
    end
  end

  def destroy
    if @activity_execution.destroy
      render status: :ok, json: { success: true, data: nil }
    else
      render status: :bad_request, json: { success: false }
    end
  end

  def import
    import_service = ActivityExecutionsImport.new(params.require(:import).permit(:file)[:file], @activity)
    if import_service.call
      redirect_to @activity, flash: { success: I18n.t('activity_execution.import.success',
                                                      count: import_service.imported_items_count) }
    else
      @import_errors = import_service.errors
      render 'activities/show'
    end
  rescue TypeError
    redirect_to @activity, flash: { error: I18n.t('activity_execution.import.invalid_file_type') }
  end

  private

  def filter
    @filter ||= ActivityExecutionFilter.new(filter_params).tap do |filter|
      filter.activity = @activity.id if @activity
    end
  end

  def set_spots
    @spots = Spot.all.includes(:fields).order(Arel.sql("LOWER(spots.name->>'de')"))
  end

  def activity_execution_params
    params.require(:activity_execution).permit(:starts_at, :ends_at, :field_id, :spot_id, :change_notification,
                                               :amount_participants, :transport_ids, :transport, :change_remarks,
                                               :mixed_languages, languages: []).tap do |params|
      convert_language_array_to_flags(params) if params[:languages]
    end
  end

  def filter_params
    params[:activity_execution_filter]&.permit(%i[spot field starts_at_after ends_at_before activity
                                                  min_available_headcount max_units])
  end

  def convert_language_array_to_flags(params)
    Activity::LANGUAGES.each do |language|
      params[language] = params[:languages].include? language.to_s.sub('language_', '')
    end
    params.delete('languages')
  end
end
